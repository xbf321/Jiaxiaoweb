using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace Jiaxiaoweb.Data
{
    public static class ExamErrorLibraryRepository
    {
        /// <summary>
        /// 保存用户错题纪录到数据库
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="questionId"></param>
        public static void InsertErrorLibrary(int userId,int questionId) {
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("  DECLARE @RowCount AS INT; ");
            sbSQL.Append("  SELECT @RowCount = COUNT(ErrorLibraryID) FROM ExamErrorLibrary WHERE UserID = @UserID AND QuestionID = @QuestionID; ");
            sbSQL.Append("  IF @RowCount = 0    ");
            sbSQL.Append("      BEGIN   ");
            sbSQL.Append("          INSERT INTO ExamErrorLibrary(UserID,QuestionID,ErrorCount,LastUpdateTime) VALUES(@UserID,@QuestionID,0,GETDATE()) ");
            sbSQL.Append("      END ");
            sbSQL.Append("  ELSE    ");
            sbSQL.Append("      BEGIN   ");
            sbSQL.Append("          UPDATE ExamErrorLibrary SET ErrorCount = ErrorCount + 1,LastUpdateTime = GETDATE() WHERE UserID = @UserID AND QuestionID = @QuestionID    ");
            sbSQL.Append("      END ");

            SqlParameter[] parms = { 
                                    new SqlParameter("@UserID",SqlDbType.Int),
                                    new SqlParameter("@QuestionID",SqlDbType.Int)
                                   };
            parms[0].Value = userId;
            parms[1].Value = questionId;

            SqlHelper.ExecuteNonQuery(CommandType.Text,sbSQL.ToString(),parms);

        }
        /// <summary>
        /// 保存用户错题纪录到数据库
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="questionIds"></param>
        public static void InsertErrorLibrary(int userId,int[] questionIds) { 
            foreach(int q in questionIds){
                if(q != 0 && q != -1){
                    InsertErrorLibrary(userId,q);
                }
            }
        }
        /// <summary>
        /// 删除错题纪录
        /// </summary>
        /// <param name="userId">UserID</param>
        /// <param name="errorLibraryId"></param>
        public static void DeleteErrorLibrary(int userId,int questionId) {
            string strSQL = "DELETE ExamErrorLibrary WHERE UserID = @UserID AND QuestionId = @QuestionId";
            SqlParameter[] parms = { 
                                    new SqlParameter("@UserID",SqlDbType.Int),
                                    new SqlParameter("@QuestionId",SqlDbType.Int)
                                   };
            parms[0].Value = userId;
            parms[1].Value = questionId;

            SqlHelper.ExecuteNonQuery(CommandType.Text,strSQL,parms);
        }
    }
}
