using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Jiaxiaoweb.Entities
{
    public class Member
    {
        private int _userId;
        public int UserID
        {
            get {
                return _userId;
            }
            set {
                _userId = value;
            }
        }

        private string _email;
        public string Email {
            get {
                return _email;
            }
            set {
                _email = value;
            }
        }

        private string _password;

        public string Password
        {
            get { return _password; }
            set { _password = value; }
        }

        private DateTime _createTime;

        public DateTime CreateTime
        {
            get { return _createTime; }
            set { _createTime = value; }
        }
    }
}
