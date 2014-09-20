
namespace Jiaxiaoweb.Entities
{
    public class ExamAnswer
    {
        private int _answerId;
        public int AnswerID
        {
            get
            {
                return _answerId;
            }
            set
            {
                _answerId = value;
            }
        }

        private int _questionId;
        public int QuestionID {
            get { return _questionId; }
            set { _questionId = value; }
        }

        private string _answerName;
        public string AnswerName {
            get { return _answerName; }
            set { _answerName = value; }
        }
    }
}
