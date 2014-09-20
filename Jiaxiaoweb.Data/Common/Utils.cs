using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Jiaxiaoweb.Common
{
    public static class Utils
    {
        private static readonly string INTPATTERN = @"^\d+$";
        public static bool IsInt(string s) { 
            if(string.IsNullOrEmpty(s)){
                return false;
            }
            if(s.Length > 0 && s.Length < 11 && Regex.IsMatch(s,INTPATTERN)){
                return true;
            }
            return false;
        }
        /// <summary>
        /// 检查获取的车证类型是否在1-6的范围内
        /// 如果没有,则说明用户恶意输入
        /// </summary>
        /// <param name="i"></param>
        /// <returns></returns>
        public static bool IsExistInDriverArray(int i)
        {
            bool isExist = false;
            int[] iArray = { 1, 2, 3, 4, 5, 6 };
            foreach (int item in iArray)
            {
                if (item == i)
                {
                    isExist = true;
                    break;
                }
            }
            return isExist;
        }
        public static void SerializeString(string aString, StringBuilder builder)
        {
            char[] charArray = aString.ToCharArray();
            for (int i = 0; i < charArray.Length; i++)
            {
                char c = charArray[i];
                if (c == '"')
                {
                    builder.Append("\\\"");
                }
                else if (c == '\\')
                {
                    builder.Append("\\\\");
                }
                else if (c == '\b')
                {
                    builder.Append("\\b");
                }
                else if (c == '\f')
                {
                    builder.Append("\\f");
                }
                else if (c == '\n')
                {
                    builder.Append("\\n");
                }
                else if (c == '\r')
                {
                    builder.Append("\\r");
                }
                else if (c == '\t')
                {
                    builder.Append("\\t");
                }
                else
                {
                    int codepoint = Convert.ToInt32(c);
                    if ((codepoint >= 32) && (codepoint <= 126))
                    {
                        builder.Append(c);
                    }
                    else
                    {
                        builder.Append("\\u" + Convert.ToString(codepoint, 16).PadLeft(4, '0'));
                    }
                }
            }
        }
        /// <summary>
        /// 把数据库中正确答案数字转义字符串
        /// </summary>
        /// <param name="rightAnswer"></param>
        /// <param name="qt"></param>
        /// <returns></returns>
        public static string ReturnRightAnswerToString(int rightAnswer, QuestionType qt)
        {
            string _returnValue = "A";

            //选择题
            if (qt == QuestionType.Choice)
            {
                switch (rightAnswer)
                {
                    case 1:
                        _returnValue = "A";
                        break;
                    case 2:
                        _returnValue = "B";
                        break;
                    case 3:
                        _returnValue = "C";
                        break;
                    case 4:
                        _returnValue = "D";
                        break;
                    case 5:
                        _returnValue = "E";
                        break;
                }
            }

            //判断题
            if (qt == QuestionType.Judgmeng)
            {
                switch (rightAnswer)
                {
                    case 1:
                        _returnValue = "对";
                        break;
                    case 2:
                        _returnValue = "错";
                        break;
                }
            }

            return _returnValue;
        }

    }
}
