using System.Text;
using System.Collections.Generic;
using Jiaxiaoweb.Common;
using Jiaxiaoweb.Data;
using Jiaxiaoweb.Entities;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web;
using System;
using System.Collections;

/// <summary>
/// Summary description for Question
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class QuestionForJson : System.Web.Services.WebService
{
    private const string ErrorJson = "\"error\":-1";
    private const string COOKIENAME = "ErrorLibrary";

    #region == WebService 外部公开方法 ==

    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    public string MyErrorLabiary(string action, int questionId)
    {
        //
        string _returnValue = string.Empty;

        #region == Add ==
        if (action == "add")
        {
            if (questionId != -1 && questionId != 0)
            {
                string myErrorLibraryQuestionId = GetCookie("myErrorLibraryQuestionId").Replace("-1", "");
                if (!HttpContext.Current.Request.IsAuthenticated)
                {                    
                    if (!string.IsNullOrEmpty(myErrorLibraryQuestionId))
                    {
                        string[] questionIds = myErrorLibraryQuestionId.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        bool _isContainer = false;

                        //检查Cookie中是否已经存在该问题ID
                        foreach (string s in questionIds)
                        {
                            if (s == questionId.ToString())
                            {
                                _isContainer = true;
                                break;
                            }
                        }

                        if (!_isContainer)
                        {
                            //如果不包含，则添加新的
                            myErrorLibraryQuestionId = string.Format("{0},{1}", myErrorLibraryQuestionId, questionId);
                        }

                        SetCookie("myErrorLibraryQuestionId", myErrorLibraryQuestionId);
                    }
                    else
                    {
                        SetCookie("myErrorLibraryQuestionId", questionId.ToString());
                    }
                }
                else { 
                    //在登录的情况下,纪录到数据库

                    Member member = MemberRepository.MemberInfo(User.Identity.Name);

                    if (!string.IsNullOrEmpty(myErrorLibraryQuestionId))
                    {
                        //把Cookie中的错误问题转移到数据库
                        List<int> questionIdsList = new List<int>();
                        foreach (string s in myErrorLibraryQuestionId.Split(new char[]{','},StringSplitOptions.RemoveEmptyEntries)) { 
                            if(!string.IsNullOrEmpty(s)){
                                int q = Convert.ToInt32(s);
                                if(q != -1 && q != 0){
                                    questionIdsList.Add(q);
                                }
                            }
                        }

                        ExamErrorLibraryRepository.InsertErrorLibrary(member.UserID,questionIdsList.ToArray());

                        //清空Cookie中的错误问题
                        SetCookie("myErrorLibraryQuestionId", "");
                    }
                    else {
                        ExamErrorLibraryRepository.InsertErrorLibrary(member.UserID,questionId);
                    }
                }
            }
        }

        #endregion

        #region == Get ==
        if (action == "get")
        {
            StringBuilder sbText = new StringBuilder("{");
            //未登录，查Cookie
            if (!HttpContext.Current.Request.IsAuthenticated)
            {
                string[] _myErrorLibraryQuestionIds = GetCookie("myErrorLibraryQuestionId").Replace("-1", "").Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                //string _errorLastUpdateTime = GetCookie("myErrorLibraryLastUpdateTime");
                if (_myErrorLibraryQuestionIds.Length > 0)
                {
                    //sbText.AppendFormat("\"errorlibrarylastupdatetime\":{0},",_errorLastUpdateTime);
                    sbText.AppendFormat("\"examquestioncount\":{0},", _myErrorLibraryQuestionIds.Length);
                    sbText.AppendFormat("\"examquestions\":[");


                    IList<ExamQuestion> examQuestionList = new List<ExamQuestion>();
                    int _step = 0;
                    foreach (string _questionId in _myErrorLibraryQuestionIds)
                    {
                        _step++;
                        sbText.Append(GetQuestionEntityForJson(Convert.ToInt32(_questionId)));
                        if (_step != _myErrorLibraryQuestionIds.Length)
                        {
                            sbText.Append(",");
                        }
                    }
                    sbText.Append("]");


                }

            }
            sbText.Append("}");
            _returnValue = sbText.ToString();
        }
        #endregion

        #region == Delete ==
        if (action == "delete")
        {
            if (questionId == -1)   //删除所有
            {
                if (!HttpContext.Current.Request.IsAuthenticated)
                {
                    //在没有登录的情况下清空Cookie
                    SetCookie("myErrorLibraryQuestionId", "");
                }
            }
            else
            {
                //删除单个问题
                string[] _myErrorLibraryQuestionIds = GetCookie("myErrorLibraryQuestionId").Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                List<string> _questionIdsList = new List<string>();
                if (_myErrorLibraryQuestionIds.Length > 0)
                {
                    foreach (string s in _myErrorLibraryQuestionIds)
                    {
                        if (s != questionId.ToString())
                        {
                            _questionIdsList.Add(s);
                        }
                    }
                }
                if (_questionIdsList.Contains("-1"))
                {
                    _questionIdsList.Remove("-1");
                }
                _questionIdsList.Sort();

                SetCookie("myErrorLibraryQuestionId", string.Join(",", _questionIdsList.ToArray()));

                //如果用户登录，则同时删除保存在数据库中的错题纪录
                if(HttpContext.Current.Request.IsAuthenticated){
                    //
                    Member member = MemberRepository.MemberInfo(User.Identity.Name);
                    ExamErrorLibraryRepository.DeleteErrorLibrary(member.UserID,questionId);
                }
            }
        }
        #endregion

        return _returnValue;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void UpdateExamQuestionClickCount(int questionId)
    {
        ExamQuestionRepository.UpdateExamQuestionClickCount(questionId);
    }
    [WebMethod]
    public void UpdateExamQuestionErrorCount(int questionId)
    {
        ExamQuestionRepository.UpdateExamQuestionErrorCount(questionId);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    //顺序练习
    public string Sxlx(int driverId, string categories)
    {
        IList<ExamQuestion> examQuestionList = ExamQuestionRepository.GetExamQuestionListForSxlx(driverId, categories, QuestionType.All);
        return GetQuestionListForJson(examQuestionList);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    //随机练习
    public string Sjlx(int driverId, string categories)
    {
        IList<ExamQuestion> examQuestionList = ExamQuestionRepository.GetExamQuestionListForSjlx(driverId, categories, QuestionType.All);
        return GetQuestionListForJson(examQuestionList);
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    //模拟考试
    public string Mnks(int driverId, int provinceId)
    {
        StringBuilder sbText = new StringBuilder("{");
        IList<ExamQuestion> examQuestionList = ExamQuestionRepository.GetExamQuestionListForMnks(driverId, provinceId);
        int _questionCount = examQuestionList.Count;
        sbText.AppendFormat("\"examquestioncount\":{0},", _questionCount);
        sbText.AppendFormat("\"examquestions\":[");
        int _step = 0;
        foreach (ExamQuestion item in examQuestionList)
        {
            _step++;
            sbText.Append(GetQuestionEntityForJson(item.QuestionID));
            if (_step != _questionCount)
            {
                sbText.Append(",");
            }
        }
        sbText.Append("]");

        sbText.Append("}");
        return sbText.ToString();
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    //强化练习
    public string Qhlx(int totalCount, int exerciseType)
    {
        IList<ExamQuestion> examQuestionList = ExamQuestionRepository.GetExamQuestionListForQhlx(totalCount, exerciseType);
        return GetQuestionListForJson(examQuestionList);
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    //获得单条问题详细信息
    public string GetQuestionEntity(int questionId)
    {
        StringBuilder sbText = new StringBuilder("(");
        if (questionId != 0)
        {
            sbText.Append(GetQuestionEntityForJson(questionId));
        }
        else
        {
            sbText.Append("{");
            sbText.Append(ErrorJson);  //没有问题，返回错误，代码为-1
            sbText.Append("}");
        }
        sbText.Append(")");

        return sbText.ToString();
    }
    #endregion

    #region == WebService 内部调用 未公开 ==
    private string GetQuestionListForJson(IList<ExamQuestion> examQuestionList)
    {
        StringBuilder sbText = new StringBuilder("{");
        sbText.AppendFormat("\"examquestioncount\":{0},", examQuestionList.Count);
        sbText.Append("\"examquestions\":[");
        int step = 0;
        int examQuestionCount = examQuestionList.Count;
        foreach (ExamQuestion item in examQuestionList)
        {
            sbText.Append("{");
            sbText.AppendFormat("\"questionid\":{0}", item.QuestionID);

            if (step == (examQuestionCount - 1))
            {
                sbText.Append("}");
            }
            else
            {

                sbText.Append("},");
            }
            step++;
        }
        sbText.Append("]}");

        return sbText.ToString();
    }
    private string GetQuestionEntityForJson(int questionId)
    {
        StringBuilder sbText = new StringBuilder("{");
        ExamQuestion examQuestion = ExamQuestionRepository.GetExamQuestionByQuestionId(questionId);
        if (examQuestion != null)
        {
            sbText.AppendFormat("\"questionid\":{0},", examQuestion.QuestionID);
            sbText.AppendFormat("\"clickcount\":{0},", examQuestion.ClickCount);
            sbText.AppendFormat("\"questiontype\":{0},", (int)examQuestion.QuestionType);
            sbText.Append("\"questionphoto\":\"");
            Utils.SerializeString(examQuestion.QuestionPhoto, sbText);
            sbText.Append("\",");

            sbText.Append("\"questionremark\":\"");
            if (string.IsNullOrEmpty(examQuestion.QuestionRemark))
            {
                Utils.SerializeString("Sorry!该题暂时没有说明!<br />我们会尽快对该题说明补充完整。", sbText);
            }
            else
            {
                Utils.SerializeString(examQuestion.QuestionRemark, sbText);
            }
            sbText.Append("\",");

            sbText.Append("\"rightanswerstring\":\"");
            Utils.SerializeString(examQuestion.RightAnswerString, sbText);
            sbText.Append("\",");

            sbText.AppendFormat("\"wrongcount\":{0},", examQuestion.WrongCount);
            if (examQuestion.QuestionType == QuestionType.Judgmeng)
            {
                sbText.Append("\"questionname\":\"");
                Utils.SerializeString(examQuestion.QuestionName, sbText);
                sbText.Append("\"");
            }
            if (examQuestion.QuestionType == QuestionType.Choice)
            {
                sbText.Append("\"questionname\":\"");
                Utils.SerializeString(examQuestion.QuestionName, sbText);
                sbText.Append("\u003C\u0062\u0072\u0020\u002F\u003E");
                IList<ExamAnswer> examAnswerList = examQuestion.AnswerList;
                foreach (ExamAnswer item in examAnswerList)
                {
                    Utils.SerializeString(item.AnswerName, sbText);
                    sbText.Append("\u003C\u0062\u0072\u0020\u002F\u003E");
                }
                sbText.Append("\"");
            }
        }
        else
        {
            sbText.Append(ErrorJson);  //没有问题，返回错误，代码为-1
        }
        sbText.Append("}");
        return sbText.ToString();
    }
    private string GetCookie(string key)
    {
        string s = string.Empty;
        if (HttpContext.Current.Request.Cookies[COOKIENAME] != null)
        {
            s = HttpContext.Current.Request.Cookies[COOKIENAME][key];
        }
        return s;
    }
    private void SetCookie(string key, string value)
    {
        SetCookie(key, value, DateTime.Now.AddDays(1));
    }
    private void SetCookie(string key, string value, DateTime expires)
    {
        HttpCookie aCookie = new HttpCookie(COOKIENAME);
        if (value == "")
        {
            //删除Cookie
            aCookie.Values[key] = value;
            aCookie.Expires = DateTime.Now.AddDays(-1);
        }
        else
        {
            aCookie.Values[key] = value;
            if (expires == null)
            {
                aCookie.Expires = DateTime.Now.AddYears(1);
            }
            else
            {
                aCookie.Expires = expires;
            }
        }
        HttpContext.Current.Response.Cookies.Add(aCookie);
    }
    #endregion



}

