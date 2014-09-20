
namespace Jiaxiaoweb.Entities
{
    public class ExamCategory
    {
        private int _categoryId;
        public int CategoryID {
            get { return _categoryId; }
            set { _categoryId = value; }
        }

        private int _parentId;
        public int ParentID {
            get { return _parentId; }
            set { _parentId = value; }
        }

        private string _categoryName;
        public string CategoryName {
            get { return _categoryName; }
            set { _categoryName = value; }
        }

        private string _categoryPath;
        public string CategoryPath {
            get { return _categoryPath; }
            set { _categoryPath = value; }
        }

        private int _categoryDepth;
        public int CategoryDepth {
            get { return _categoryDepth; }
            set { _categoryDepth = value; }
        }

        private int _categoryOrder;
        public int CategoryOrder
        {
            get { return _categoryOrder; }
            set { _categoryOrder = value; }
        }


    }
}
