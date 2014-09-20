using System;

namespace Jiaxiaoweb.Entities
{
    public class ExamErrorLibrary
    {
        private int _errorLibraryId;

        public int ErrorLibraryId
        {
            get { return _errorLibraryId; }
            set { _errorLibraryId = value; }
        }

        private int _userId;

        public int UserId
        {
            get { return _userId; }
            set { _userId = value; }
        }

        private int _questionId;

        public int QuestionId
        {
            get { return _questionId; }
            set { _questionId = value; }
        }

        private int _errorCount;

        public int ErrorCount
        {
            get { return _errorCount; }
            set { _errorCount = value; }
        }

        private DateTime _lastUpdateTime;

        public DateTime LastUpdateTime
        {
            get { return _lastUpdateTime; }
            set { _lastUpdateTime = value; }
        }
    }
}
