using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// 基于login_information表的各种操作
/// </summary>
namespace Login_Information.BLL { 
    public class LoginInformation
    {
	    public LoginInformation()
	    {
		    //
		    // TODO: 在此处添加构造函数逻辑
		    //
	    }
        /// <summary>
        /// 根据参数ID，获取各类信息 返回dataset
        /// </summary>

        public DataSet LoadDataAll()
        {
            Database db = new Database();		//实例化一个Database类
            login_information login_information1 = new login_information();

            string sql = "SELECT * FROM login_information ";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }

        /// <summary>
        /// 根据参数ID，获取各类信息 返回数据库类dataset
        /// </summary>
        /// <param name="ID">ID号</param>

        public DataSet LoadData(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            login_information login_information1 = new login_information();

            string sql = "SELECT * FROM login_information WHERE ID = '" + ID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }

        /// <summary>
        /// 获得ID 要更新的数据的名称和数值
        /// </summary>
        /// <param name="ID">ID号</param>
        /// <param name="name">数据名</param>
        /// <param name="value">值</param>
        public Boolean Update_Data_Only(string ID, string name, string value)
        {
            Database db = new Database();		//实例化一个Database类
            //更新语句
            if(name =="ID"||name =="name")
                return false;
            string sql = "UPDATE login_information set " + name + " = '" + value + "' WHERE ID = '" + ID + "'";
            if (db.UpdateData(sql))
                return true;
            return false;
        }

        /// <summary>
        /// 获得ID  更新数据
        /// </summary>

        /// <param name="login_information1">数据</param>

        public Boolean Update_Data(login_information login_information1)
        {
            Database db = new Database();		//实例化一个Database类
            //更新语句
            string sql = "SELECT * FROM login_information WHERE ID = '" + login_information1.ID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            if (dataset.Tables[0].Rows.Count > 0)
            {

                login_information1.creat_time = (System.DateTime)dataset.Tables[0].Rows[0]["creat_time"];

            }
            DateTime old = new DateTime(1900,01,01,0,0,0);
            TimeSpan ts = old - (DateTime)login_information1.creat_time;
            
            if (ts.Minutes==0)
            {
                
                sql = "UPDATE login_information set idebtity= '" + login_information1.idebtity +
                                                      "',  email  = '" + login_information1.email +
                                                      "',   QQ    = '" + login_information1.QQ +
                                                      "',  phonenumber_long = '" + login_information1.phonenumber_long +
                                                      "',  phonenumber_short='" + login_information1.phonenumber_short +
                                                      "', address = '" + login_information1.address +
                                                      "', creat_time ='" + DateTime.Now
                                                           + "' WHERE ID = '" + login_information1.ID + "'";
            }
            else
            {
                  sql = "UPDATE login_information set idebtity= '" + login_information1.idebtity+
                                                   "',  email  = '" + login_information1.email +
                                                   "',   QQ    = '" +login_information1.QQ +
                                                   "',  phonenumber_long = '" + login_information1.phonenumber_long +
                                                   "',  phonenumber_short='" +login_information1.phonenumber_short+
                                                   "', address = '" + login_information1.address+
                                                   "' WHERE ID = '" + login_information1.ID + "'";
            }
           
            if (db.UpdateData(sql))
                return true;
            return false;
        }



        /// <summary>
        /// 获得ID  得到最新登陆时间
        /// </summary>
        /// <param name="ID">ID号</param>


        public DateTime Get_last_time(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "SELECT last_time FROM login_information WHERE ID = '" + ID + "'";
            DateTime last_time = new DateTime();
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            if (dataset.Tables[0].Rows.Count > 0)
            {

                last_time = (System.DateTime)dataset.Tables[0].Rows[0]["last_time"];

            }
            else
            {
               
            }

            return last_time;
        }


        /// <summary>
        /// 获得ID  更新最新登陆时间
        /// </summary>
        /// <param name="ID">ID号</param>


        public Boolean Update_last_time(string ID)
        {
            Database db = new Database();		//实例化一个Database类
           
              string  sql = "UPDATE login_information set last_time ='" + DateTime.Now
                                                      + "' WHERE ID = '" + ID + "'";
           

            if (db.UpdateData(sql))
                return true;
            return false;
        }
    }
}