using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data.SqlClient;
using System.Data;

namespace Student.BLL
{
    public class StudentInfo
    {
        public StudentInfo()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 获得所有个人信息 返回数据库类dataset
        /// </summary>
        public DataSet LoadDataAll()
        {
            Database db = new Database();		//实例化一个Database类
            login_information login_information1 = new login_information();

            string sql = "SELECT  b.ID,b.name,b.idebtity,b.email,b.QQ,b.phonenumber_long,b.phonenumber_short,b.address FROM login_rank as a join login_information as b on a.ID = b.ID where a.rank_student <> '没有权限' order by idebtity ";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        public DataSet LoadDataByID(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            login_information login_information1 = new login_information();

            string sql = "SELECT  ID,name,idebtity,email,QQ,phonenumber_long,phonenumber_short,address FROM login_information  WHERE ID = '" + ID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
      
        /// <summary>
        /// 用户状态
        /// </summary>
        public DataSet State(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "SELECT last_time,state FROM Student_Infor  WHERE ID = '" + ID + "'";
                DataSet dataset = new DataSet();
                dataset = db.GetDataSet(sql);
                return dataset;
            

        }
        /// <summary>
        /// 更改用户状态
        /// </summary>
        public Boolean Change_State(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            if (db.CheckData("SELECT * FROM Student_Infor WHERE ID = '" + ID + "'"))
            {
                string sql = "SELECT name,last_time,state FROM Student_Infor  WHERE ID = '" + ID + "'";
                DataSet dataset = new DataSet();
                dataset = db.GetDataSet(sql);
                string name = dataset.Tables[0].Rows[0]["name"].ToString().Trim();
                string state = dataset.Tables[0].Rows[0]["state"].ToString().Trim();
                DateTime dt =Convert.ToDateTime(dataset.Tables[0].Rows[0]["last_time"]);
                DateTime dt2 = DateTime.Now;
                TimeSpan ts = dt2 - dt;
                if (state == "已签到")
                {
                    if(ts.Days.ToString()=="0")
                    {
                        state = "已签退";
                        dt = DateTime.Now;
                    }
                    else
                    {
                        state = "未正常签退";
                        sql = "Insert into Student_Signtime(ID,name,date_time,state) Values('"
                                                + ID + "','"
                                                + name + "','"
                                                + dt + "','"
                                                + state + "')";
                        db.UpdateData(sql);

                        state = "已签到";
                        dt = DateTime.Now;

                    }
                }
                else
                {
                    state = "已签到";
                    dt = DateTime.Now;
                }
                sql = "Insert into Student_Signtime(ID,name,date_time,state) Values('"
                                                + ID + "','"
                                                + name + "','"
                                                + dt + "','"
                                                + state + "')";
                if (db.UpdateData(sql))
                {
                    sql = "UPDATE Student_Infor set state= '" + state +
                                                        "',  last_time  = '" + dt +
                                                     "' WHERE ID = '" + ID + "'";
                    if (db.UpdateData(sql))
                        return true;

                }
                return false;
               

            }
            else
            {
                string sql = "SELECT name FROM login_information  WHERE ID = '" + ID + "'";
                DataSet dataset = new DataSet();
                dataset = db.GetDataSet(sql);
                string name = dataset.Tables[0].Rows[0]["name"].ToString().Trim();
                string state = "已签到";
                DateTime dt = DateTime.Now;
                sql = "Insert into Student_Signtime(ID,name,date_time,state) Values('"
                                               + ID + "','"
                                               + name + "','"
                                               + dt + "','"
                                               + state + "')";
                if (db.UpdateData(sql))
                {
                    sql = "Insert into Student_Infor(ID,name,last_time,state) Values('"
                                               + ID + "','"
                                               + name + "','"
                                               + dt + "','"
                                               + state + "')";

                    if (db.UpdateData(sql))
                        return true;

                }
                return false;
            }

           
        }

    }
    public class StudentFreeTime
    {
        public StudentFreeTime()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 根据参数ID，获取各类信息 返回dataset
        /// </summary>

        public DataSet LoadDataByID(string ID)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "SELECT * FROM Student_Freetime where ID ='" + ID + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 根据参数ID，获取各类信息 返回dataset
        /// </summary>

        public DataSet LoadDataByTime_Type(string time_type)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "SELECT b.freetime_id, b.ID,b.name,b.time_type FROM login_rank as a join Student_Freetime as b on a.ID = b.ID where a.rank_student <> '没有权限'and time_type ='" + time_type + "'";
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        public DataSet LoadDataByTime_TypeOnly(string time_type, string date_time)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "SELECT m.freetime_id, m.ID,m.name,m.time_type FROM login_rank as n join Student_Freetime as m on n.ID = m.ID where n.rank_student <> '没有权限' and not exists(select 1 from Student_Worktime as b where b.date_time ='" + date_time + "'and m.ID =b.ID and b.time_type ='" + time_type + "' ) and m.time_type ='" + time_type + "'";
            
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 插入更新信息
        /// </summary>
        public Boolean Insert_Data(Student_Freetime Student_Freetime1)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "Insert into Student_Freetime(ID,name,time_type) Values('"
                                                + Student_Freetime1.ID + "','"
                                                + Student_Freetime1.name + "','"
                                                + Student_Freetime1.time_type + "')";
            

            if (db.UpdateData(sql))
                return true;
            return false;
        }
        /// <summary>
        /// 删除某个用户的空闲时间表
        /// <param ID="ID">ID</param>
        /// </summary>
        public Boolean DeleteData(string ID)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Student_Freetime  where ID ='" + ID + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 删除某个空闲时间段
        /// <param ID="ID">ID</param>
        /// </summary>
        public Boolean DeleteDataByFreetimeid(string freetime_id)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Student_Freetime  where freetime_id ='" + freetime_id + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }
    public class StudentWorkTime
    {
        public StudentWorkTime()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 根据时间，获取各类信息 返回dataset
        /// </summary>
        public DataSet FindAllDataByTime(string time1, string time2)
        {
          
            string sql;
            sql = "SELECT * FROM Student_Worktime WHERE date_time between '" + time1 + "' and '" + time2 + "'  order by time_type";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 根据时间，获取某人的信息 返回dataset
        /// </summary>
        public DataSet FindDataByID(string search, string time1, string time2)
        {

            string sql;
            sql = "SELECT * FROM Student_Worktime WHERE  ID ='" + search + "' and date_time between '" + time1 + "' and '" + time2 + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 插入更新信息
        /// </summary>
        public Boolean Insert_Data(Student_Worktime Student_Worktime1)
        {
            Database db = new Database();		//实例化一个Database类

            string sql = "Insert into Student_Worktime(ID,name,time_type,date_time) Values('"
                                                + Student_Worktime1.ID + "','"
                                                + Student_Worktime1.name + "','"
                                                + Student_Worktime1.time_type + "','"
                                                + Student_Worktime1.date_time + "')";


            if (db.UpdateData(sql))
                return true;
            return false;
        }
        /// <summary>
        /// <param ID="ID">ID</param>
        /// </summary>
        public Boolean DeleteData(string date_time)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Student_Worktime  where date_time ='" + date_time + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// <param ID="ID">ID</param>
        /// </summary>
        public Boolean DeleteDataByTimeid(string time_id)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Student_Worktime  where time_id ='" + time_id + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
       
    }
    public class StudentSignTime
    {
        public StudentSignTime()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 根据参数ID，获取各类信息 返回dataset
        /// </summary>
        public DataSet FindDataByName(string ID, string time1, string time2)
        {
            time2 += " 23:59:59";
            //DateTime t = Convert.ToDateTime(time2);

            //t.AddDays(1);
            //t.ToString("yyyy-MM-dd");
            string sql;
            sql = "SELECT * FROM Student_Signtime WHERE ID = '" + ID + "' and date_time between '" + time1 + "' and '" + time2 + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        
    
        /// <summary>
        /// 根据参数ID，获取各类信息 返回dataset
        /// </summary>
        public DataSet FindDataAll( string time1, string time2)
        {
            time2 += " 23:59:59";
            //DateTime t = Convert.ToDateTime(time2);

            //t.AddDays(1);
            //t.ToString("yyyy-MM-dd");
            string sql;
            sql = "SELECT * FROM Student_Signtime WHERE  date_time between '" + time1 + "' and '" + time2 + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        
    }


}
