using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Jiaxiaoweb.Entities;

namespace Jiaxiaoweb.Data
{
    public static class MemberRepository
    {
        /// <summary>
        /// 注册新用户
        /// </summary>
        /// <param name="email"></param>
        /// <param name="password"></param>
        /// <returns>返回用户ID,如果返回-1,说明该用户已存在</returns>
        public static int CreateMember(string email,string password) {
            if(IsExists(email)){
                return -1; 
            }
            string strSQL = "INSERT INTO Member(Email,[Password],CreateTime) VALUES(@Email,@Password,GETDATE());SELECT @@IDENTITY";
            SqlParameter[] parms = { 
                                    new SqlParameter("@Email",SqlDbType.VarChar),
                                    new SqlParameter("@Password",SqlDbType.VarChar)
                                   };
            parms[0].Value = email;
            parms[1].Value = password;
            return Convert.ToInt32(SqlHelper.ExecuteScalar(CommandType.Text,strSQL,parms));
        }
        /// <summary>
        /// 判断用户是否存在
        /// </summary>
        /// <param name="email"></param>
        /// <returns>True:存在 False:不存在</returns>
        public static bool IsExists(string email) {
            string strSQL = "SELECT COUNT(UserID) FROM Member WHERE Email = @Email";
            SqlParameter parm = new SqlParameter("@Email",email);
            if(Convert.ToInt32(SqlHelper.ExecuteScalar(CommandType.Text,strSQL,parm)) == 0){
                return false;
            }
            return true;
        }
        /// <summary>
        /// 验证用户是否存在
        /// </summary>
        /// <param name="email"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public static bool ValidatorMember(string email,string password) {
            string strSQL = "SELECT COUNT(UserID) FROM Member WHERE Email = @Email AND [Password] = @Password";
            SqlParameter[] parms = { 
                                    new SqlParameter("@Email",SqlDbType.VarChar),
                                    new SqlParameter("@Password",SqlDbType.VarChar)
                                   };
            parms[0].Value = email;
            parms[1].Value = password;
            return Convert.ToInt32(SqlHelper.ExecuteScalar(CommandType.Text,strSQL,parms)) > 0;
        }

        public static Member MemberInfo(string email) {
            Member member = null;
            string strSQL = "SELECT UserID,Email,CreateTime FROM Member WHERE Email = @Email";
            SqlParameter parm = new SqlParameter("@Email",email);
            using(SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text,strSQL,parm)){
                if(dr.Read()){
                    member = new Member();
                    member.CreateTime = Convert.ToDateTime(dr["CreateTime"]);
                    member.Email = dr["Email"].ToString();
                    member.UserID = Convert.ToInt32(dr["UserId"]);
                }
            }
            return member;
        }
    }
}
