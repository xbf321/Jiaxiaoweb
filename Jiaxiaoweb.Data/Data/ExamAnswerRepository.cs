using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Jiaxiaoweb.Entities;

namespace Jiaxiaoweb.Data
{
    public static class ExamAnswerRepository
    {
        public static IList<ExamAnswer> GetExamAnswerListByQuestonId(int questionId) { 

            IList<ExamAnswer> examAnswerList = new List<ExamAnswer>();
            ExamAnswer examAnswer = null;
            string strSql = "SELECT AnswerId,QuestionId,AnswerName FROM ExamAnswer WHERE QuestionID = @QuestionId ORDER BY AnswerID ASC";
            SqlParameter parm = new SqlParameter("@QuestionID",questionId);
            using(SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text,strSql,parm)){
                while(dr.Read()){
                    examAnswer = new ExamAnswer();
                    examAnswer.AnswerID = Convert.ToInt32(dr["AnswerId"]);
                    examAnswer.AnswerName = dr["AnswerName"].ToString();
                    examAnswer.QuestionID = questionId;

                    examAnswerList.Add(examAnswer);
                }
            }

            return examAnswerList;
        }
    }
}
