using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using Jiaxiaoweb.Data;
using System.Data;
using System.Net;

namespace TestConsole
{
    public static class DownloadImage
    {
        public static void Down() {
            List<string> urlList = new List<string>();
            string strSql = "SELECT QuestionID, QuestionPhoto FROM ExamQuestion WHERE QuestionPhoto <> '' ";
            using(SqlDataReader dr = SqlHelper.ExecuteReader(CommandType.Text,strSql)){
                while(dr.Read()){
                    urlList.Add(dr["QuestionPhoto"].ToString());
                }
            }

            Down(urlList);
        }
        private static void Down(List<string> urlList) {
            string dir = @"E:\temp\www_jiaxiaoweb_com\Jiaxiaoweb.Web\upload\questionphoto\";
            WebClient wc = new WebClient();
            foreach (var item in urlList)
            {
                string _path = dir + GetImageName(item);
                string _u = "http://kaoshi.jiaxiao.com" + item;

                Console.WriteLine(_path);
                wc.DownloadFile(new Uri(_u), _path);
                
            }
        }
        private static string GetImageName(string url)
        {
            string name = string.Empty;

            url = url.Substring(url.LastIndexOf('/') + 1);
            return url;
        }
    }
}
