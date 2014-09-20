using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Jiaxiaoweb.Entities;
using Jiaxiaoweb.Common;

namespace Jiaxiaoweb.Data
{
    public static class ExamQuestionRepository
    {
        private const string EXAMQUESTIONFILEDLIST = "CategoryId,QuestionID,ClickCount,QuestionPhoto,QuestionName,QuestionRemark,QuestionType,RightAnswer,WrongCount,QuestionLibrary ";

        #region == 强化练习 ==
        /// <summary>
        /// 强化练习
        /// </summary>
        /// <param name="totalCount">共多少道题</param>
        /// <param name="exerciseType">1:顺序 2:随机</param>
        /// <returns></returns>
        public static IList<ExamQuestion> GetExamQuestionListForQhlx(int totalCount, int exerciseType)
        {
            IList<ExamQuestion> examQuestionList = new List<ExamQuestion>();
            ExamQuestion examQuestion = null;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("    SELECT QuestionID FROM ( ");
            sbSQL.AppendFormat("        SELECT TOP {0} QuestionID FROM ExamQuestion ORDER BY WrongCount DESC ", totalCount);
            sbSQL.Append("    ) AS QuestionInfo   ");
            if (exerciseType == 2)
            {
                sbSQL.Append("  ORDER BY NEWID()    ");
            }

            using (SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text, sbSQL.ToString()))
            {
                while (dr.Read())
                {
                    examQuestion = GetExamQuestionByQuestionId(Convert.ToInt32(dr["QuestionID"]));
                    examQuestionList.Add(examQuestion);
                }
            }

            return examQuestionList;
        }
        #endregion

        #region == 顺序练习 ==
        /// <summary>
        /// 顺序练习
        /// </summary>
        /// <param name="driverId"></param>
        /// <param name="qt"></param>
        /// <returns></returns>
        public static IList<ExamQuestion> GetExamQuestionListForSxlx(int driverId, string categories, QuestionType qt)
        {
            return GetExamQuestionList(driverId, categories, qt, ExerciseType.Ordinal);
        }
        #endregion

        #region == 随机练习 ==
        /// <summary>
        /// 随机练习
        /// </summary>
        /// <param name="driverId"></param>
        /// <param name="qt"></param>
        /// <returns></returns>
        public static IList<ExamQuestion> GetExamQuestionListForSjlx(int driverId, string categories, QuestionType qt)
        {
            return GetExamQuestionList(driverId, categories, qt, ExerciseType.Random);
        }
        #endregion

        #region == 获得问题集合 ==
        /// <summary>
        /// 获得问题集合
        /// </summary>
        /// <param name="driverId">驾驶证类型</param>
        /// <param name="provinceId">省份</param>
        /// <param name="qt">问题类型,选择题或者判断题,Null:说明包含全部题</param>
        /// <param name="categoryId">类别ID,可以是多个类别</param>
        /// <returns></returns>
        public static IList<ExamQuestion> GetExamQuestionList(int driverId, string categories, QuestionType qt, ExerciseType et)
        {
            string[] _categoryArray = categories.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            List<int> _categoryList = new List<int>();
            IList<ExamQuestion> examQuestionList = new List<ExamQuestion>();
            ExamQuestion examQuestion = null;
            StringBuilder sbSql = new StringBuilder();

            sbSql.AppendFormat("  SELECT {0}  ", EXAMQUESTIONFILEDLIST);
            sbSql.Append("  FROM ExamQuestion   ");
            sbSql.Append("  INNER JOIN (    ");


            //判断是否根据用户选择分类来获取问题
            foreach (string s in _categoryArray)
            {
                if (Utils.IsInt(s))
                {
                    int __i = Convert.ToInt32(s);
                    if (__i > 0 && __i < 100)
                    {
                        //把0和分类ID大于100的排除掉
                        //因为总的分类ID也超不过100
                        _categoryList.Add(__i);
                    }
                }
            }

            if (_categoryList.Count > 0)
            {
                sbSql.Append(ExamCategoryRepository.GetCategoryUnionAllTable(_categoryList));
            }
            else
            {
                sbSql.Append(ExamCategoryRepository.GetCategoryTableStringByDriverType(driverId));
            }

            sbSql.Append("  ) AS CategoryList   ");
            sbSql.Append("  ON ExamQuestion.CategoryID = CategoryList.CID    ");
            sbSql.Append("  WHERE   1 = 1   ");
            switch (driverId)
            {
                case 1:     //小车
                case 2:     //客车专用
                case 3:     //货车专用
                case 4:     //吊车电瓶车
                case 5:     //地方试题
                    sbSql.Append(" AND ExamQuestion.QuestionLibrary = 1    ");
                    break;
                case 6:     //摩托车
                    sbSql.Append(" AND ExamQuestion.QuestionLibrary = 2    ");
                    break;
            }

            if (qt == QuestionType.Choice)
            {
                sbSql.Append("  AND ExamQuestion.QuestionType = 1   ");
            }
            if (qt == QuestionType.Judgmeng)
            {
                sbSql.Append("  AND ExamQuestion.QuestionType = 2   ");
            }

            if (et == ExerciseType.Random)
            {
                sbSql.Append("  ORDER BY NEWID()    ");
            }

            using (SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text, sbSql.ToString()))
            {
                while (dr.Read())
                {
                    examQuestion = GetExamQuestionByQuestionId(Convert.ToInt32(dr["QuestionID"]));
                    examQuestionList.Add(examQuestion);
                }
            }
            return examQuestionList;
        }
        #endregion

        #region == 模拟考试 ==
        /// <summary>
        /// 根据每个章节中要抽取的试题比重，获得【通用模拟考试】中的100道题
        /// h1-h7,为通用中各个章节
        /// h8为地方性法规
        /// h9客车专用知识
        /// h10货车专用知识
        /// h11汽车吊车、电瓶车、轮式专用机械专用试题
        /// </summary>
        /// <param name="h1">道路交通安全法律、法规和规章</param>
        /// <param name="h2">道路交通信号</param>
        /// <param name="h3">安全行车、文明驾驶知识</param>
        /// <param name="h4">高速公路、山区道路、桥梁、隧道、夜间、恶劣气象和复杂道路条件下的安全驾驶知识</param>
        /// <param name="h5">出现爆胎、转向失控和制动失灵等紧急情况临危处置知识</param>
        /// <param name="h6">机动车总体构造常识、常见故障判断，车辆日常检查和维护</param>
        /// <param name="h7">发生交通事故后的自救、急救等一般知识，危险品相关知识</param>
        /// <param name="h8">为地方性法规</param>
        /// <param name="h9">客车专用知识</param>
        /// <param name="h10">货车专用知识</param>
        /// <param name="h11">汽车吊车、电瓶车、轮式专用机械专用试题</param>
        /// <param name="questionLibarary">1:汽车,2:摩托车</param>
        /// <param name="provinceId">省份ID</param>
        /// <returns></returns>
        private static IList<ExamQuestion> GetCommonChapterOneHundredQuestionList(int h1, int h2, int h3, int h4, int h5, int h6, int h7, int h8, int h9, int h10, int h11, int questionLibarary,int provinceId) {
            IList<ExamQuestion> examQuestionList = new List<ExamQuestion>();
            ExamQuestion examQuestion = null;
            StringBuilder sbSQL = new StringBuilder();

            sbSQL.AppendFormat("  SELECT {0}  ", EXAMQUESTIONFILEDLIST);
            sbSQL.Append("  FROM (   ");

            //h1 ,CategoryId:13
            sbSQL.Append(GetChapterExamQuestionSqlString(13, true, h1, questionLibarary));
            sbSQL.Append("  UNION ALL   ");

            //h2,CategoryId:14
            sbSQL.Append(GetChapterExamQuestionSqlString(14, true, h2, questionLibarary));
            sbSQL.Append("  UNION ALL   ");

            //h3,CategoryId:15
            sbSQL.Append(GetChapterExamQuestionSqlString(15, true, h3, questionLibarary));
            sbSQL.Append("  UNION ALL   ");

            //h4,CategoryId:16
            sbSQL.Append(GetChapterExamQuestionSqlString(16, true, h4, questionLibarary));
            sbSQL.Append("  UNION ALL   ");

            //h5,CategoryId:17
            sbSQL.Append(GetChapterExamQuestionSqlString(17, true, h5, questionLibarary));
            sbSQL.Append("  UNION ALL   ");

            //h6,CategoryId:28
            sbSQL.Append(GetChapterExamQuestionSqlString(28, true, h6, questionLibarary));
            sbSQL.Append("  UNION ALL   ");

            //h7,CategoryId:29
            sbSQL.Append(GetChapterExamQuestionSqlString(29, true, h7, questionLibarary));
            sbSQL.Append("  UNION ALL   ");

            //h8,CategoryId:5,地方专用试题

            if (provinceId == -1)
            {
                sbSQL.Append(GetChapterExamQuestionSqlString(5, true, h8, questionLibarary));
            }
            else {
                //地方地
                sbSQL.Append(GetChapterExamQuestionSqlString(provinceId, true, h8, questionLibarary));
            }
            sbSQL.Append("  UNION ALL   ");

            if (h9 != 0)
            {
                //h9,CategoryId:11
                sbSQL.Append(GetChapterExamQuestionSqlString(11, true, h9, 1));
                sbSQL.Append("  UNION ALL   ");
            }

            if (h10 != 0)
            {
                //h10,CategoryId:10
                sbSQL.Append(GetChapterExamQuestionSqlString(10, true, h10, 1));
                sbSQL.Append("  UNION ALL   ");
            }

            if (h11 != 0)
            {
                //h11,CategoryId:12
                sbSQL.Append(GetChapterExamQuestionSqlString(12, true, h11, 1));
            }
            else
            {
                sbSQL.AppendFormat(" SELECT TOP 0 {0} FROM ExamQuestion", EXAMQUESTIONFILEDLIST);
            }

            sbSQL.Append("  ) AS a  ");
            sbSQL.Append("  ORDER BY NEWID()    ");

            using (SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text, sbSQL.ToString()))
            {
                while (dr.Read())
                {
                    examQuestion = GetExamQuestionByQuestionId(Convert.ToInt32(dr["QuestionID"]));
                    examQuestionList.Add(examQuestion);
                }
            }
            return examQuestionList;
        }
        /// <summary>
        /// 根据每个章节中要抽取的试题比重，获得【通用模拟考试】中的100道题
        /// h1-h7,为通用中各个章节
        /// h8为地方性法规
        /// h9客车专用知识
        /// h10货车专用知识
        /// h11汽车吊车、电瓶车、轮式专用机械专用试题
        /// </summary>
        /// <param name="h1">道路交通安全法律、法规和规章</param>
        /// <param name="h2">道路交通信号</param>
        /// <param name="h3">安全行车、文明驾驶知识</param>
        /// <param name="h4">高速公路、山区道路、桥梁、隧道、夜间、恶劣气象和复杂道路条件下的安全驾驶知识</param>
        /// <param name="h5">出现爆胎、转向失控和制动失灵等紧急情况临危处置知识</param>
        /// <param name="h6">机动车总体构造常识、常见故障判断，车辆日常检查和维护</param>
        /// <param name="h7">发生交通事故后的自救、急救等一般知识，危险品相关知识</param>
        /// <param name="h8">为地方性法规</param>
        /// <param name="h9">客车专用知识</param>
        /// <param name="h10">货车专用知识</param>
        /// <param name="h11">汽车吊车、电瓶车、轮式专用机械专用试题</param>
        /// <param name="questionLibarary">1:汽车,2:摩托车</param>
        /// <returns></returns>
        private static IList<ExamQuestion> GetCommonChapterOneHundredQuestionList(int h1, int h2, int h3, int h4, int h5, int h6, int h7, int h8, int h9, int h10, int h11, int questionLibarary)
        {
            return GetCommonChapterOneHundredQuestionList(h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,questionLibarary,-1);
        }
        private static string GetChapterExamQuestionSqlString(int categoryId, bool isContainSelf, int topCount, int questionLibrary)
        {
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.AppendFormat(" SELECT {1} FROM ( SELECT TOP {0} {1}  ", topCount, EXAMQUESTIONFILEDLIST);
            sbSQL.Append("  FROM ExamQuestion   ");
            sbSQL.Append("  INNER JOIN (    ");
            sbSQL.Append(ExamCategoryRepository.GetCategoryTableStringByCategoryId(categoryId, isContainSelf));
            sbSQL.Append("  ) AS CategoryList   ");
            sbSQL.Append("  ON ExamQuestion.CategoryID = CategoryList.CID    ");
            sbSQL.AppendFormat("  WHERE QuestionLibrary = {0}   ", questionLibrary);
            sbSQL.AppendFormat("  ORDER BY NEWID()  ) AS a_{0}  ", categoryId);
            return sbSQL.ToString();
        }

        /// <summary>
        /// 模拟考试
        /// </summary>
        /// <param name="driverId"></param>
        /// <param name="provinceId">-1是全部的</param>
        /// <returns></returns>
        public static IList<ExamQuestion> GetExamQuestionListForMnks(int driverId,int provinceId)
        {
            IList<ExamQuestion> examQuestionList = null;
            if (provinceId != -1)
            {
                //目前只涉及到某个省的小车的模拟考试
                //对于某个省的客车、货车、吊车、电瓶车没有做处理
                //以后升级在说

                examQuestionList = GetCommonChapterOneHundredQuestionList(25, 20, 20, 10, 10, 5, 5, 5, 0, 0, 0, 1,provinceId);
            }
            else
            {
                switch (driverId)
                {
                    case 1: //小车
                        examQuestionList = GetCommonChapterOneHundredQuestionList(25, 20, 20, 10, 10, 5, 5, 5, 0, 0, 0, 1);
                        break;
                    case 2: //客车
                        examQuestionList = GetCommonChapterOneHundredQuestionList(25, 15, 20, 10, 10, 5, 5, 5, 5, 0, 0, 1);
                        break;
                    case 3: //货车
                        examQuestionList = GetCommonChapterOneHundredQuestionList(25, 15, 20, 10, 10, 5, 5, 5, 0, 5, 0, 1);
                        break;
                    case 4: //吊车，电拼车
                        examQuestionList = GetCommonChapterOneHundredQuestionList(25, 15, 20, 10, 10, 5, 5, 5, 0, 0, 5, 1);
                        break;
                    case 6: //摩托车
                        examQuestionList = GetCommonChapterOneHundredQuestionList(25, 25, 25, 10, 5, 1, 4, 5, 0, 0, 0, 2);
                        break;
                }
            }
            return examQuestionList;
        }
        #endregion

        #region == 获得单条问题实体 ==
        /// <summary>
        /// 获得问题实体
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        public static ExamQuestion GetExamQuestionByQuestionId(int questionId)
        {
            ExamQuestion examQuestion = null;

            string strSql = string.Format("SELECT {0} FROM ExamQuestion WHERE QuestionId = @QuestionID ", EXAMQUESTIONFILEDLIST);
            SqlParameter parm = new SqlParameter("@QuestionId", questionId);
            using (SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text, strSql, parm))
            {
                if (dr.Read())
                {
                    examQuestion = new ExamQuestion();
                    examQuestion.CategoryID = Convert.ToInt32(dr["CategoryID"]);
                    examQuestion.ClickCount = Convert.ToInt32(dr["ClickCount"]);
                    examQuestion.QuestionID = questionId;
                    examQuestion.QuestionLibrary = Convert.ToInt32(dr["QuestionLibrary"]);
                    examQuestion.QuestionName = dr["QuestionName"].ToString();
                    examQuestion.QuestionPhoto = string.IsNullOrEmpty(dr["QuestionPhoto"].ToString()) == true ? "" : "/upload/questionphoto/" + dr["QuestionPhoto"].ToString();
                    examQuestion.QuestionRemark = dr["QuestionRemark"].ToString();
                    examQuestion.QuestionType = Convert.ToInt32(dr["QuestionType"]) == 1 ? QuestionType.Choice : QuestionType.Judgmeng;
                    examQuestion.RightAnswer = Convert.ToInt32(dr["RightAnswer"]);
                    examQuestion.RightAnswerString = Utils.ReturnRightAnswerToString(examQuestion.RightAnswer, examQuestion.QuestionType);
                    examQuestion.WrongCount = Convert.ToInt32(dr["WrongCount"]);

                    if (examQuestion.QuestionType == QuestionType.Choice)
                    {
                        //该题为选择题
                        examQuestion.AnswerList = ExamAnswerRepository.GetExamAnswerListByQuestonId(questionId);
                    }
                }
            }

            return examQuestion;
        }
        #endregion

        #region == 获得某一分类下的问题数 ==
        public static int GetQuestionCountByCategoryId(int driverId, int categoryId, QuestionType qt)
        {

            List<int> _categoryIdList = new List<int>();
            IList<ExamCategory> examCategoryList = ExamCategoryRepository.GetExamCategoryListByParentId(categoryId, true);
            foreach (ExamCategory item in examCategoryList)
            {
                _categoryIdList.Add(item.CategoryID);
            }

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("  SELECT COUNT(QuestionID) FROM ExamQuestion ");
            sbSQL.Append("  WHERE EXISTS (");
            sbSQL.Append("      SELECT CID FROM (");
            sbSQL.Append(ExamCategoryRepository.GetCategoryUnionAllTable(_categoryIdList));
            sbSQL.Append("      ) AS C WHERE C.CID = ExamQuestion.CategoryID    ");
            sbSQL.Append("  ) ");
            if (driverId == (int)DriverType.Moto)
            {
                //摩托车单独处理
                sbSQL.Append(" AND ExamQuestion.QuestionLibrary = 2    ");
            }
            else
            {
                sbSQL.Append(" AND ExamQuestion.QuestionLibrary = 1    ");
            }
            if (qt == QuestionType.Choice)
            {
                sbSQL.Append("  AND ExamQuestion.QuestionType = 1   ");
            }
            if (qt == QuestionType.Judgmeng)
            {
                sbSQL.Append("  AND ExamQuestion.QuestionType = 2   ");
            }

            return Convert.ToInt32(SqlHelper.ExecuteScalar(CommandType.Text, sbSQL.ToString()));
        }
        #endregion

        #region == 更新问题浏览数 ==
        /// <summary>
        /// 更新问题浏览数
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        public static int UpdateExamQuestionClickCount(int questionId) {
            string strSQL = string.Format("UPDATE dbo.ExamQuestion SET ClickCount = ClickCount + 1 WHERE QuestionID = {0}",questionId);
            SqlHelper.ExecuteNonQuery(CommandType.Text,strSQL);
            return 0;
        }
        #endregion

        #region == 更新问题错误数 ==
        /// <summary>
        /// 更新问题错误数
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        public static int UpdateExamQuestionErrorCount(int questionId) {
            string strSQL = string.Format("UPDATE dbo.ExamQuestion SET WrongCount = WrongCount + 1 WHERE QuestionID = {0}", questionId);
            SqlHelper.ExecuteNonQuery(CommandType.Text, strSQL);
            return 0;
        }
        #endregion

        #region == 获得我的错误问题集合 ==
        public static IList<ExamQuestion> GetErrorLibraryQuestionList(int userId) {
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.AppendFormat("  SELECT QuestionId FROM ExamQuestion  ");
            sbSQL.Append("  WHERE EXISTS(   ");
            sbSQL.Append("      SELECT * FROM ExamErrorLibrary  ");
            sbSQL.Append("      WHERE ExamErrorLibrary.UserId = @UserID   ");
            sbSQL.Append("      AND ExamQuestion.QuestionID = ExamErrorLibrary.QuestionID   ");
            sbSQL.Append("  )   ");

            SqlParameter parm = new SqlParameter("@UserID",userId);

            IList<ExamQuestion> examQuestionList = new List<ExamQuestion>();
            ExamQuestion examQuestion = null;
            using(SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text,sbSQL.ToString(),parm)){
                while(dr.Read()){
                    examQuestion = GetExamQuestionByQuestionId(Convert.ToInt32(dr["QuestionId"]));
                    examQuestionList.Add(examQuestion);
                }
            }
            return examQuestionList;
        }
        #endregion
    }
}
