using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data;
using System.Collections;
using System.Data.SqlClient;
///
///基于login_rank表的各种操作
///

namespace Login_Rank_Information.BLL
{
    public class LoginRankInformation
	{
			 #region 方法
        public LoginRankInformation()
        {

        }
        /// <summary>
        /// 根据参数ID，获取权限信息 返回数据库类login_rank
        /// </summary>
        /// <param name="ID">ID号</param>
    
        public login_rank LoadData(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            login_rank login_rank1 = new login_rank(); 
         
                string sql = "SELECT * FROM login_rank WHERE ID = '"+ ID +"'";
                DataSet dataset = new DataSet();
                dataset = db.GetDataSet(sql);
                if (dataset.Tables[0].Rows.Count>0)
                {
                    //从数据库中取值（数据库改变后需要在这里添加新的变量）
                    login_rank1.ID = dataset.Tables[0].Rows[0]["ID"].ToString().Trim();
                    login_rank1.PW = dataset.Tables[0].Rows[0]["PW"].ToString().Trim();
                    login_rank1.name = dataset.Tables[0].Rows[0]["name"].ToString().Trim();
                    login_rank1.question = dataset.Tables[0].Rows[0]["question"].ToString().Trim();
                    login_rank1.answer = dataset.Tables[0].Rows[0]["answer"].ToString().Trim();
                    login_rank1.rank_control = dataset.Tables[0].Rows[0]["rank_control"].ToString ().Trim();
                    login_rank1.rank_news = dataset.Tables[0].Rows[0]["rank_news"].ToString().Trim();
                    login_rank1.rank_drug = dataset.Tables[0].Rows[0]["rank_drug"].ToString().Trim();
                    login_rank1.rank_equipment = dataset.Tables[0].Rows[0]["rank_equipment"].ToString().Trim();
                    login_rank1.rank_experment = dataset.Tables[0].Rows[0]["rank_experment"].ToString().Trim();
                    login_rank1.rank_class = dataset.Tables[0].Rows[0]["rank_class"].ToString().Trim();
                    login_rank1.rank_course = dataset.Tables[0].Rows[0]["rank_course"].ToString().Trim();
                    login_rank1.rank_student = dataset.Tables[0].Rows[0]["rank_student"].ToString().Trim();
                    login_rank1.rank_open = dataset.Tables[0].Rows[0]["rank_open"].ToString().Trim();   
                }
                else
                {
                    login_rank1.ID = "#";
                    login_rank1.PW = "#";
                }

            return login_rank1;
        }

        public string Image(string str)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "Insert into ImageCheck(str,date) Values('"
                                                + str + "','"
                                                + DateTime.Now + "')";

            if (db.UpdateData(sql))
            {
                sql = "SELECT * FROM ImageCheck WHERE str = '" + str + "'";
                DataSet dataset = new DataSet();
                dataset = db.GetDataSet(sql);
                if (dataset.Tables[0].Rows.Count > 0)
                {
                    //从数据库中取值（数据库改变后需要在这里添加新的变量）
                     return dataset.Tables[0].Rows[0]["No"].ToString();


                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "false";
            }
          

        }
        public Boolean ImageCheck(string No,string str)
        {
            Database db = new Database();
            string sql = "SELECT * FROM ImageCheck WHERE No = '" + No + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            sql = "Delete ImageCheck  WHERE No='" + No + "'";
            db.UpdateData(sql);
            if (dataset.Tables[0].Rows.Count > 0)
            {
                //从数据库中取值（数据库改变后需要在这里添加新的变量）
                
                string str2 = dataset.Tables[0].Rows[0]["str"].ToString().Trim();

                DateTime old = (System.DateTime)dataset.Tables[0].Rows[0]["date"];
                TimeSpan ts =  DateTime.Now-old;
                if (ts.Days == 0 && ts.Hours * 60 + ts.Minutes <= 1 && String.Equals(str, str2, StringComparison.CurrentCultureIgnoreCase))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else{
                return false;
            }

        }
        public Boolean Token(string ID,string token)
        {
            Database db = new Database();		//实例化一个Database类
            login_rank login_rank1 = new login_rank();

            string sql = "SELECT * FROM login_rank WHERE ID = '" + ID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            if (dataset.Tables[0].Rows.Count > 0)
            {
                //从数据库中取值（数据库改变后需要在这里添加新的变量）
                login_rank1.token = dataset.Tables[0].Rows[0]["token"].ToString().Trim();
                login_rank1.token_Time = (System.DateTime)dataset.Tables[0].Rows[0]["token_Time"];

            }
            else
            {
                return false;
            }
            DateTime now = DateTime.Now;
            TimeSpan ts = now - (DateTime)login_rank1.token_Time;
            if (token.Equals(login_rank1.token)&&ts.Days<=6)
            {
                return true;
            }
            else{
                return false;
            }
            
        }

        /// <summary>
        /// 根据参数ID，获取权限信息 返回dataset
        /// </summary>
        /// <param name="ID">ID号</param>

        public DataSet LoadDataByDataSet(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            login_rank login_rank1 = new login_rank();

            string sql = "SELECT * FROM login_rank WHERE ID = '" + ID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        /// <summary>
        /// 根据参数ID，获取问题 返回dataset
        /// </summary>
        /// <param name="ID">ID号</param>

        public DataSet GetQA(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            login_rank login_rank1 = new login_rank();

            string sql = "SELECT question FROM login_rank WHERE ID = '" + ID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
       

        /// <summary>
        /// 获得ID 要更新的数据的名称和数值 更新该数据(因为权限可能会有所增加 所以这边非常规设置 函数可以灵活使用)
        /// </summary>
        /// <param name="ID">ID号</param>
        /// <param name="name">数据名</param>
        /// <param name="value">值</param>
        public Boolean Update_Data(string ID, string name,string value)
        {
            Database db = new Database();		//实例化一个Database类
            //更新语句
            string sql = "UPDATE login_rank set "+ name +" = '"+value +"' WHERE ID = '" + ID + "'";
            if(db.UpdateData(sql))
            return true;
            return false;
        }
        /// <summary>
        /// 获得ID 删除该数据
        /// </summary>
        /// <param name="ID">ID号</param>
        public Boolean Delete_Data(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            //删除语句
            string sql = "Delete login_rank  WHERE ID='" + ID + "'";
            if (db.UpdateData(sql))
                return true;

            return false;
        }
        /// <summary>
        /// 获取所有权限信息
        /// </summary>
        public DataSet LoadData_all()
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "SELECT * FROM login_rank ";

            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 获取所有对某个权限具有某种权限的用户列表
        /// </summary>
        public DataSet LoadDataByRank(string name, string value)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "SELECT ID,name FROM login_rank where " + name +" = '" + value + "'";

            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }

        /// <summary>
        /// 获得信息 插入该数据
        /// </summary>
        /// <param name="login_rank1">login_rank1</param>
        public Boolean Insert_Data(login_rank login_rank1)
        {
            Database db = new Database();		//实例化一个Database类   
           //判断id是否存在
            string sql;
            if (db.CheckData("SELECT ID FROM login_rank WHERE ID = '" + login_rank1.ID + "'"))
            {
                return false;
            }
            else
            {
                 sql = "Insert into login_rank(ID,PW,name,question,answer,rank_control,rank_news,rank_drug,"
                                                + "rank_equipment,rank_experment,rank_course,rank_class,rank_student,rank_open) Values('"
                                                + login_rank1.ID + "','"
                                                + login_rank1.ID + "','"
                                                + login_rank1.name + "','"
                                                + "未回答" + "','"
                                                + "" + "','"
                                                + login_rank1.rank_control + "','"
                                                + login_rank1.rank_news + "','"
                                                + login_rank1.rank_drug + "','"
                                                + login_rank1.rank_equipment + "','"
                                                + login_rank1.rank_experment + "','"
                                                + login_rank1.rank_course + "','"
                                                + login_rank1.rank_class + "','"
                                                + login_rank1.rank_student + "','"
                                                + login_rank1.rank_open + "')";
            }
                
            
           
            if (db.UpdateData(sql))
                return true;

            return false;
        }

        /// <summary>
        /// 获得信息 更新名字及权限信息
        /// </summary>
        /// <param name="login_rank1">login_rank1</param>
        public Boolean Update_Data(login_rank login_rank1)
        {
            Database db = new Database();		//实例化一个Database类   
            string sql;
            //判断id是否存在
            if (db.CheckData("SELECT ID FROM login_rank WHERE ID = '" + login_rank1.ID + "'"))
            {
                sql = "UPDATE  login_rank SET  name = '" + login_rank1.name +
                                          "' , rank_control = ' " + login_rank1.rank_control +
                                          "' , rank_news = ' " + login_rank1.rank_news +
                                          "' , rank_drug = ' " + login_rank1.rank_drug +
                                          "' , rank_equipment = ' " + login_rank1.rank_equipment +
                                          "' , rank_experment = ' " + login_rank1.rank_experment +
                                          "' , rank_course = ' " + login_rank1.rank_course +
                                           "' , rank_class = ' " + login_rank1.rank_class +
                                            "' , rank_student = ' " + login_rank1.rank_student +
                                             "' , rank_open = ' " + login_rank1.rank_open + 
                                          " ' where ID ='" + login_rank1.ID + "'";
            }
            else
            {
                
                return false;
            }



            if (db.UpdateData(sql))
                return true;

            return false;
        }
        #endregion 方法
	}
}