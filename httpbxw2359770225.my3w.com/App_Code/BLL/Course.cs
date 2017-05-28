using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data;
namespace Course.BLL
{
    /// <summary>
    /// CourseInfo 的摘要说明
    /// </summary>
    public class CourseInfo
    {
        public CourseInfo()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 通过课程名称或者院系查找某些课程 返回dataset数据
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet LoadData(string search)
        {
            string sql;
            sql = "SELECT * FROM Course_Information WHERE course LIKE '%" + search + "%' OR faculty LIKE '%" + search + "%'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        /// <summary>
        /// 添加删除 
        /// 
        /// 
        public Boolean Add_UpdateData(Course_Information course_Information, string course)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类
            if (db.CheckData("SELECT course FROM Course_Information WHERE course = '" + course + "'"))
            {
                sql = "UPDATE  Course_Information SET  course = '" + course_Information.course +
                                                "' ,detail = '" + course_Information.detail +
                                                 "' , faculty = ' " + course_Information.faculty +
                                                " ' where course ='" + course + "'";

            }

            else
            {
                sql = "Insert into Course_Information(course,detail,faculty) Values('"
                                                + course_Information.course + "','"
                                                + course_Information.detail + "','"
                                                + course_Information.faculty + "')";
            }


            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个课程
        /// <param name="drug_name">药品名</param> 
        /// </summary>
        public Boolean DeleteData(string course)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Course_Information  where course ='" + course + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }

    /// <summary>
    /// CourseExper 的摘要说明
    /// </summary>
    public class CourseExper
    {
        public CourseExper()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        /// 通过课程名称查询查找实验
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT * FROM Course_Exper WHERE course = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 通过课程名称更新课程对应实验 返回true
        /// </summary>
        /// <param name="Course_Exper">Course_Exper数据类</param> 
        /// 
        public Boolean Add_UpdateData(Course_Exper course_Exper)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类



            sql = "Insert into Course_Exper(course,experment_name) Values('"
                                                + course_Exper.course + "','"
                                                + course_Exper.experment_name + "')";



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个课程对应的实验
        /// <param name="course">课程名</param> 
        /// </summary>
        public Boolean DeleteData(string course)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Course_Exper  where course ='" + course + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

    }

    /// <summary>
    /// Course_Login 的摘要说明
    /// </summary>
    public class CourseLogin
    {
        public CourseLogin()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        /// 通过用户ID查询其管理的课程
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindDataByID(string search)
        {
            
            string sql;
            sql = "SELECT * FROM Course_Login WHERE ID = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// 通过课程名称查询其管理的用户
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindDataByExp(string search)
        {
            string sql;
            sql = "SELECT * FROM Course_Login WHERE course = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 判断用户是否有权限修改 返回true
        /// </summary>
        /// 
        public Boolean Rank(string course, string id)
        {
            Database db = new Database();		//实例化一个Database类
            return db.CheckData("SELECT course FROM Course_Login WHERE course = '" + course + "' and id = '" + id + "'");
        }
        /// <summary>
        /// 判断用户是否有权限添加用户 返回true
        /// </summary>
        /// 
        public Boolean Rank_add(string course, string id)
        {
            Database db = new Database();		//实例化一个Database类
            return db.CheckData("SELECT course FROM Course_Login WHERE course = '" + course + "' and id = '" + id + "'" + " and isAdd = '具备'");
        }
        /// <summary>
        /// 通过课程名称更新权限 返回true
        /// </summary>
        /// <param name="Experment_Login">Experment_Login数据类</param> 
        /// 
        public Boolean Add_UpdateData(Course_Login course_Login)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类



            sql = "Insert into Course_Login(course,ID,name) Values('"
                                                + course_Login.course + "','"
                                                + course_Login.ID + "','"
                                                + course_Login.name + "')";



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个实验对应权限
        /// <param name="experment_name">实验名</param> 
        /// </summary>
        public Boolean DeleteData(string course)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Course_Login  where course ='" + course + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }
}