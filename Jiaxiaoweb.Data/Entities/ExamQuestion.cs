
using System.Collections.Generic;
using Jiaxiaoweb.Common;
namespace Jiaxiaoweb.Entities
{
    public class ExamQuestion
    {
        private int _questionId;
        public int QuestionID {
            get { return _questionId; }
            set { _questionId = value; }
        }

        private int _categoryId;
        public int CategoryID {
            get { return _categoryId; }
            set { _categoryId = value; }
        }

        private QuestionType _questionType;
        public QuestionType QuestionType
        {
            get { return _questionType; }
            set { _questionType = value; }
        }

        private string _questionName;
        public string QuestionName {
            get { return _questionName; }
            set { _questionName = value; }
        }

        private string _questionPhoto;
        public string QuestionPhoto {
            get { return _questionPhoto; }
            set { _questionPhoto = value; }
        }

        private string _questionRemark;
        public string QuestionRemark {
            get { return _questionRemark; }
            set { _questionRemark = value; }
        }

        private int _rightAnswer;
        public int RightAnswer {
            get { return _rightAnswer; }
            set { _rightAnswer = value; }
        }

        private string _rightAnswerString;
        public string RightAnswerString {
            get { return _rightAnswerString; }
            set { _rightAnswerString = value; }
        }

        private int _clickCount;
        public int ClickCount {
            get { return _clickCount; }
            set { _clickCount = value; }
        }

        private int _wrongCount;
        public int WrongCount {
            get { return _wrongCount; }
            set { _wrongCount = value; }
        }

        /// <summary>
        /// 是“汽车”，还是摩托车
        /// 1:汽车，2:摩托车
        /// </summary>
        private int _questionLibrary;
        public int QuestionLibrary {
            get { return _questionLibrary; }
            set { _questionLibrary = value; }
        }

        private IList<ExamAnswer> _answerList;
        public IList<ExamAnswer> AnswerList {
            get { 
                if(_answerList == null){
                    _answerList  = new List<ExamAnswer>();                   
                }
                return _answerList;
            }
            set { _answerList = value; }
        }
    }
}
