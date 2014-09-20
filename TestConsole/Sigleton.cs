using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TestConsole
{
    public class Category {
        public int CategoryID { get; set; }
        public List<Category> Children { get; set; }
    }
    public class CategoryLoader
    {
        private object m_mutex = new object();
        private Dictionary<int, Category> m_categories;
        public Category GetCategory(int id) { 
            if(this.m_categories == null){
                lock(this.m_mutex){
                    LoadCategories();        
                }
            }
            return this.m_categories[id];
        }
        private void LoadCategories() {
            this.m_categories = new Dictionary<int, Category>();
            this.Fill(GetCategoryRoot());

        }
        private void Fill(IEnumerable<Category> categories) { 
            foreach(var item in categories){
                this.m_categories.Add(item.CategoryID,item);
                Fill(item.Children);
            }
        }

        private IEnumerable<Category> GetCategoryRoot() {
            return null;
        }
    }
}
