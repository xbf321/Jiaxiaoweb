using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jiaxiaoweb.Common;
using Jiaxiaoweb.Data;
using Jiaxiaoweb.Entities;
using System.Data;

namespace TestConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            //Dictionary<int, int> a = new Dictionary<int, int>();
            //Console.WriteLine(a==null);

            //Console.WriteLine("sdf");
            ExamCategoryConsole();

            //Console.WriteLine(ExamQuestionRepository.GetCommonChapterOneHundredQuestionList(25,20,20,10,10,5,5,5,0,0,0));

            //GetCategorySqlTable();

            //IList<ExamQuestion> examQuestionList = ExamQuestionRepository.GetExamQuestionListForMnks(1);
            //Console.WriteLine(examQuestionList.Count);
            //foreach (var item in examQuestionList)
            //{
            //    Console.WriteLine(item.QuestionName);
            //}

            //Console.WriteLine(IsExistInArray(6));
            //

            //DataTable dt = EnumHelper.EnumListTable(typeof(DriverType));
            //foreach(DataRow dr in dt.Rows){
            //    //Console.WriteLine(string.Format("{0}--{1}---{2}",dr["Text"],dr["Value"],dr["Description"]));
            //}

            //string desc = EnumHelper.GetEnumDescriptionFromDataTableByValue(1,typeof(DriverType));
            //Console.WriteLine(desc);


            //DownloadImage.Down();

            Console.Read();
        }
        static bool IsExistInArray(int i) {

            bool isExist = false;
            int[] iArray = {1,2,3,4,5 };
            foreach(int item in iArray){
                if(item == i){
                    isExist = true;
                    break;
                }
            }
            return isExist;
        }
        static void GetCategorySqlTable() {
            Console.WriteLine(ExamCategoryRepository.GetCategoryTableStringByCategoryId(13,false));
        }
        static void ExamCategoryConsole(){
            IList<ExamCategory> examCategoryList = ExamCategoryRepository.GetExamCategoryListByParentId(5,true);
            //examCategoryList.Add(ExamCategoryRepository.GetExamCategoryByCategoryId(13));
            foreach(var item in examCategoryList){
                Console.WriteLine(string.Format("{0},{1},{2}",item.CategoryID,item.ParentID,item.CategoryName));
            }
        }
    }
}
