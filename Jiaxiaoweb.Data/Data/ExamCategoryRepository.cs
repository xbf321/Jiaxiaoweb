using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Jiaxiaoweb.Entities;
using System.Text;
using System.Text.RegularExpressions;

namespace Jiaxiaoweb.Data
{
    public static class ExamCategoryRepository
    {
        /// <summary>
        /// 根据ParentID
        /// 递归调用子分类
        /// 该方法不包含根
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        private static IList<ExamCategory> GetExamCategoryListByParentId(int parentId)
        {
            IList<ExamCategory> examCategoryList = new List<ExamCategory>();
            ExamCategory examCategory = null;

            string strSql = "SELECT * FROM ExamCategory WHERE Parent_ID = @ParentID ORDER BY Column_Order ASC ";
            SqlParameter parm = new SqlParameter("@ParentID",parentId);
            using(SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text,strSql,parm)){
                while(dr.Read()){
                    
                    int _categoryId = Convert.ToInt32(dr["Column_ID"]);
                    examCategory = GetExamCategoryByCategoryId(_categoryId);
                    examCategoryList.Add(examCategory);

                    IList<ExamCategory> list = GetExamCategoryListByParentId(examCategory.CategoryID);

                    foreach (ExamCategory item in list)
                    {
                        examCategoryList.Add(item);
                    }

                }
            }

            return examCategoryList;
        }
        public static IList<ExamCategory> GetExamCategoryListByParentId(int parentId,bool isContainParent) {
            IList<ExamCategory> examCategoryList = GetExamCategoryListByParentId(parentId);
            if(isContainParent){
                examCategoryList.Insert(0,GetExamCategoryByCategoryId(parentId));
            }
            return examCategoryList;
        }
        /// <summary>
        /// 根据驾驶证类型
        /// 动态生成类别表语句
        /// </summary>
        /// <param name="driverId"></param>
        /// <returns></returns>
        public static string GetCategoryTableStringByDriverType(int driverId)
        {
            IList<ExamCategory> examCategoryList = new List<ExamCategory>();
            StringBuilder sbSql = new StringBuilder();
            switch (driverId)
            {
                case 1:         //小车(通用)
                case 6:         //摩托车,用QuesitonLibrary区分
                    examCategoryList = GetExamCategoryListByParentId(1,false);
                    break;
                case 2:         //客车专用包含根
                    examCategoryList = GetExamCategoryListByParentId(11,true);
                    break;
                case 3:         //货车专用
                    examCategoryList = GetExamCategoryListByParentId(10, true);
                    break;
                case 4:         //吊车电瓶车
                    examCategoryList = GetExamCategoryListByParentId(12, true);                   
                    break;
                case 5:         //地方试题
                    break;
            }

            List<int> _categoryIds = new List<int>();
            foreach (ExamCategory item in examCategoryList)
            {
                _categoryIds.Add(item.CategoryID);
            }
            return GetCategoryUnionAllTable(_categoryIds);
        }

        /// <summary>
        /// 获得想这样的动态Sql,eg:SELECT 1 AS CategoryID UNION SELECT 2 AS CategoryID 
        /// </summary>
        /// <param name="categoryId"></param>
        /// <param name="isContainSelf">是否包含自身</param>
        /// <returns></returns>
        public static string GetCategoryTableStringByCategoryId(int categoryId,bool isContainSelf) {
            StringBuilder sbSql = new StringBuilder();

            IList<ExamCategory> examCategoryList = GetExamCategoryListByParentId(categoryId, isContainSelf);

            List<int> _categoryIds = new List<int>();
            foreach(ExamCategory item in examCategoryList){
                _categoryIds.Add(item.CategoryID);
            }

            return GetCategoryUnionAllTable(_categoryIds);
        }

        public static string GetCategoryUnionAllTable(List<int> categoryIds) {
            StringBuilder sbText = new StringBuilder();
            foreach(int i in categoryIds){
                sbText.AppendFormat("    UNION ALL SELECT {0} AS CID {1}",i, System.Environment.NewLine);
            }
            return Regex.Replace(sbText.ToString(), @"^(\s+?)UNION ALL", string.Empty);
        }

        /// <summary>
        /// 获得分类实体
        /// </summary>
        /// <param name="categoryId"></param>
        /// <returns></returns>
        public static ExamCategory GetExamCategoryByCategoryId(int categoryId)
        {
            string strSql = "SELECT * FROM ExamCategory WHERE Column_ID = @CategoryID";
            SqlParameter parm = new SqlParameter("@CategoryId",categoryId);
            ExamCategory examCategory = null;

            using(SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text,strSql,parm)){
                if(dr.Read()){
                    examCategory = new ExamCategory();
                    examCategory.CategoryDepth = Convert.ToInt32(dr["Column_Depth"]);
                    examCategory.CategoryID = categoryId;
                    examCategory.CategoryName = dr["Column_Name"].ToString();
                    examCategory.CategoryOrder = Convert.ToInt32(dr["Column_Order"]);
                    examCategory.CategoryPath = dr["Column_Path"].ToString();
                    examCategory.ParentID = Convert.ToInt32(dr["Parent_ID"]);
                }
            }
            return examCategory;
        }
    }
}
