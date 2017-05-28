using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data;
using System.Data.SqlClient;
namespace News_Information.BLL
{

    /// <summary>
    /// Login_News_information 的摘要说明
    /// </summary>
    public class NewsInformation
	{

        public NewsInformation(){

        }

        /// <summary>
        /// 输入获取类型 获取所有信息（type为新闻类型 1 或 2）
        /// </summary>
        public DataSet LoadData_all(string type)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "SELECT * FROM Login_news WHERE type = '"+type +"'order by ArticleID desc";

            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        public DataSet LoadDataFromTo(string from, string to, string search)
        {
            Database db = new Database();		//实例化一个Database类
            to += " 23:59:59";
            string sql = "SELECT * FROM Login_news WHERE Title LIKE '%" + search + "%'and DateTime between '" + from + "' and '" + to + "' order by ArticleID desc";

            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }

        public DataSet LoadData(string search)
        {
            string sql;
            sql = "select ArticleID, Title, DateTime, Member_Name, infor ,type ,Hits from Login_News   WHERE Title LIKE '%" + search+ "%'";
            



            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        /// <summary>
        /// 添加News  输入一个login_News类 如果login_News.ArticleID为-1 则为插入  否则为更新
        /// </summary>
        public  bool Add_UpdateNews(Login_News login_News)
        {
            Database db = new Database();		//实例化一个Database类
            string sql;
            if (db.CheckData("SELECT ArticleID FROM Login_News WHERE ArticleID = '" + login_News.ArticleID.ToString() + "'"))
            {
               
                sql = "UPDATE  Login_News SET  Title = '" + login_News.Title +
                                               "' ,Content_1 = '" + login_News.Content_1 +
                                               "' , DateTime = '" + DateTime.Now +
                                               "' , Member_Name = '" + login_News.Member_Name +
                                                "' , infor = '" + login_News.infor +
                                               "' , type = ' " + login_News.type +
                                                " ' where ArticleID ='" + login_News.ArticleID.ToString() + "'";
            }

            else{
                sql = "Insert into Login_News(Title,Content_1,DateTime,Member_Name,infor,type) Values('"
                                                +login_News.Title+"','"
                                                +login_News.Content_1+"','"
                                                +login_News.DateTime+"','"
                                                +login_News.Member_Name+"','"
                                                + login_News.infor + "','"
                                                +login_News.type+"')";
            }
            
         
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
       

        /// <summary>
        /// 得到最新的num条type简单记录（num为条数 type为类型 1为新闻 2为公告）
        /// </summary>
        public  DataSet GetLateNews(string num, string type)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "select top " + num + "ArticleID, Title, DateTime, Member_Name, infor ,type ,Hits from Login_News  where type ='" + type + "' order by ArticleID desc";
            return db.GetDataSet(sql);
        }
        /// <summary>
        /// 得到详细记录（ArticleID 为记录ID）
        /// </summary>
        public DataSet GetNews_Detail(string ArticleID)
        {
            Login_News login_News = new Login_News();
            Database db = new Database();		//实例化一个Database类
            string sql = "select  * from Login_News  where ArticleID ='" + ArticleID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 删除新闻（ArticleID 为记录ID）
        /// </summary>
        public Boolean DeleteNews_Detail(string ArticleID)
        {
            Login_News login_News = new Login_News();
            Database db = new Database();		//实例化一个Database类
            string sql = "select  * from Login_News  where ArticleID ='" + ArticleID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            if (dataset.Tables[0].Rows.Count == 0)
            {
                return false;
            }
            sql = "Delete Login_News  where ArticleID ='" + ArticleID + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 点击量+1（ArticleID 为记录ID）
        /// </summary>
        public Boolean Add_Hits(string ArticleID)
        {
            Database db = new Database();		//实例化一个Database类
            //查询hit值
            string sql = "select  * from Login_News  where ArticleID ='" + ArticleID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            if (dataset.Tables[0].Rows.Count != 0)
            {
                int Hits;
                Hits = Convert.ToInt32(dataset.Tables[0].Rows[0][4]);
                Hits = Hits+1;
                sql = "UPDATE  Login_News SET  Hits = '" + Hits +
                                              " ' where ArticleID ='" + ArticleID + "'";

                if (db.UpdateData(sql))
                {
                    return true;
                }
                return false;
            }
                
            return false;



           
        }
	}

 }