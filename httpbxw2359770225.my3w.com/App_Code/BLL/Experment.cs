using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data;
namespace Experment.BLL
{
    /// <summary>
    /// Experment 的摘要说明
    /// </summary>
    public class ExpermentInfo
    {
        public ExpermentInfo()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 通过实验名称等查找 返回dataset数据
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet LoadData(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_Information WHERE experment_name LIKE '%" + search + "%'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_Information WHERE experment_name = '" + search + "'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        /// <summary>
        /// 通过实验名称更新或插入 返回true
        /// <param name="experment_Information">Experment_Information数据类</param> 
        /// <param name="experment_name">实验名</param> 
        /// </summary>
        public Boolean Add_UpdateData(Experment_Information experment_Information, string experment_name)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类

            if (experment_name == "-1")
            {
                if (db.CheckData("SELECT experment_name FROM Experment_Information WHERE experment_name = '" + experment_Information.experment_name + "'"))
                {
                    return false;
                }
                else
                {
                    sql = "Insert into Experment_Information(experment_name,error,detail) Values('"
                                              + experment_Information.experment_name + "','"
                                              + experment_Information.error + "','"
                                              + experment_Information.detail + "')";
                }
            }
            else
            {
                if (db.CheckData("SELECT experment_name FROM Experment_Information WHERE experment_name = '" + experment_name + "'"))
                {
                    if (experment_name == experment_Information.experment_name)
                    {
                        sql = "UPDATE  Experment_Information SET  experment_name = '" + experment_Information.experment_name +
                                               "' ,detail = '" + experment_Information.detail +
                                                "' ,error = '" + experment_Information.error +
                                               " ' where experment_name ='" + experment_name + "'";
                    }
                    else
                    {
                        if (db.CheckData("SELECT experment_name FROM Experment_Information WHERE experment_name = '" + experment_Information.experment_name + "'"))
                        {
                            return false;
                        }
                        else
                        {
                            sql = "UPDATE  Experment_Information SET  experment_name = '" + experment_Information.experment_name +
                                                    "' ,detail = '" + experment_Information.detail +
                                                     "' ,error = '" + experment_Information.error +
                                                    " ' where experment_name ='" + experment_name + "'";
                        }
                    }
                   


                }
                else
                {
                    return false;
                }


            }
          


            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

      
        /// <summary>
        /// 删除某个实验
        /// <param name="experment_name">experment_name</param> 
        /// </summary>
        public Boolean DeleteData(string experment_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Experment_Information  where experment_name ='" + experment_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }

    /// <summary>
    /// Room 的摘要说明
    /// </summary>
    public class R_Room
    {
        public R_Room()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        ///  返回dataset数据
        /// </summary>
        ///
        /// 
        public DataSet LoadData()
        {
            string sql;
            sql = "SELECT * FROM Room";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        public DataSet FindData(string room_name)
        {
            string sql;
            sql = "SELECT * FROM Room WHERE room_name = '" + room_name + "'";



            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        /// <summary>
        /// 通过房间名更新某房间 返回true
        /// <param name="Room">Room数据类</param> 
        /// <param name="room_name">room_name</param> 
        /// </summary>
        public Boolean Add_UpdateData(Room room, string room_name)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类
            if (room_name == "-1")
            {
                if (db.CheckData("SELECT room_name FROM Room WHERE room_name = '" + room.room_name + "'"))
                {
                    return false;
                }
                else
                {
                    sql = "Insert into Room(room_name,detail) Values('"
                                               + room.room_name + "','"
                                               + room.detail + "')";
                }
            }
            else
            {

                if (db.CheckData("SELECT room_name FROM Room WHERE room_name = '" + room_name + "'"))
                {
                    if (room_name == room.room_name)
                    {
                        sql = "UPDATE  Room SET  room_name = '" + room.room_name +
                                                   "' ,detail = '" + room.detail +
                                                   " ' where room_name ='" + room_name + "'";
                    }
                    else
                    {
                        if (db.CheckData("SELECT room_name FROM Room WHERE room_name = '" + room.room_name + "'"))
                        {
                            return false;
                        }
                        else
                        {
                            sql = "UPDATE  Room SET  room_name = '" + room.room_name +
                                                       "' ,detail = '" + room.detail +
                                                       " ' where room_name ='" + room_name + "'";
                        }
                    }
                    
                   

                }

                else
                {
                    return false;
                }
            }
            


            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 删除某个房间信息
        /// <param name="experment_name">room_name</param> 
        /// </summary>
        public Boolean DeleteData(string room_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Room  where room_name ='" + room_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }


    }

    /// <summary>
    /// ExpermentRoom 的摘要说明
    /// </summary>
    public class ExpermentRoom
    {
        public ExpermentRoom()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// 通过实验名称查询对应教室
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_Room WHERE experment_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// 通过教室查询对应实验
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindDataByRoom(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_Room WHERE room_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 通过实验名称更新某教室 返回true
        /// </summary>
        /// <param name="experment_Room">Experment_Room数据类</param> 
        /// 
        public Boolean Add_UpdateData(Experment_Room experment_Room)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类



            sql = "Insert into Experment_Room(experment_name,room_name) Values('"
                                                + experment_Room.experment_name + "','"
                                                + experment_Room.room_name + "')";



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个实验对应教室
        /// <param name="experment_name">实验</param> 
        /// </summary>
        public Boolean DeleteData(string experment_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Experment_Room  where room_name ='" + experment_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    
    }

    /// <summary>
    /// ExpermentMixDrug 的摘要说明
    /// </summary>
    public class ExpermentMixDrug
    {
        public ExpermentMixDrug()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// 通过实验名称查询对应试剂
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_MixDrug WHERE experment_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 通过实验名称更新某药品 返回true
        /// </summary>
        /// <param name="experment_MixDrug">Experment_MixDrug数据类</param> 
        /// 
        public Boolean Add_UpdateData(Experment_MixDrug experment_MixDrug)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类



            sql = "Insert into Experment_MixDrug(experment_name,drug_mix,standard,num) Values('"
                                                + experment_MixDrug.experment_name + "','"
                                                + experment_MixDrug.drug_mix + "','"
                                                + experment_MixDrug.standard + "','"
                                                + experment_MixDrug.num + "')";



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个实验对应试剂
        /// <param name="experment_name">实验名</param> 
        /// </summary>
        public Boolean DeleteData(string experment_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Experment_MixDrug  where experment_name ='" + experment_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }

    /// <summary>
    /// Experment_Drug 的摘要说明
    /// </summary>
    public class ExpermentDrug
    {
        public ExpermentDrug()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// 通过实验名称查询对应药品
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_Drug WHERE experment_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 通过实验名称更新某药品 返回true
        /// </summary>
        /// <param name="Experment_Drug">Experment_Drug数据类</param> 
        /// 
        public Boolean Add_UpdateData(Experment_Drug experment_Drug)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类



            sql = "Insert into Experment_Drug(experment_name,drug_name,standard,num) Values('"
                                                + experment_Drug.experment_name + "','"
                                                + experment_Drug.drug_name + "','"
                                                + experment_Drug.standard + "','"
                                                + experment_Drug.num + "')";



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个实验对应试剂
        /// <param name="experment_name">实验名</param> 
        /// </summary>
        public Boolean DeleteData(string experment_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Experment_Drug  where experment_name ='" + experment_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }
    /// <summary>
    /// Experment_Login 的摘要说明
    /// </summary>
    public class ExpermentLogin
    {
        public ExpermentLogin()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        
        /// 通过用户ID查询其管理的实验
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindDataByID(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_Login WHERE ID = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// 通过实验名称查询其管理的用户
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet FindDataByExp(string search)
        {
            string sql;
            sql = "SELECT * FROM Experment_Login WHERE experment_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 判断用户是否有权限修改 返回true
        /// </summary>
        /// 
        public Boolean Rank(string experment_name,string id)
        {
             Database db = new Database();		//实例化一个Database类
             return db.CheckData("SELECT experment_name FROM Experment_Login WHERE experment_name = '" + experment_name + "' and id = '" + id + "'");
        }

        /// <summary>
        /// 判断用户是否有权限添加用户 返回true
        /// </summary>
        /// 
        public Boolean Rank_add(string experment_name, string id)
        {
            Database db = new Database();		//实例化一个Database类
            return db.CheckData("SELECT experment_name FROM Experment_Login WHERE experment_name = '" + experment_name + "' and id = '" + id + "'" + " and isAdd = 'true'");
        }
        /// <summary>
        /// 通过实验名称更新权限 返回true
        /// </summary>
        /// <param name="Experment_Login">Experment_Login数据类</param> 
        /// 
        public Boolean Add_UpdateData(Experment_Login experment_Login)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类



            sql = "Insert into Experment_Login(experment_name,ID,name,isAdd) Values('"
                                                + experment_Login.experment_name + "','"
                                                + experment_Login.ID + "','"
                                                + experment_Login.name + "','"
                                                + experment_Login.isAdd + "')";



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
        public Boolean DeleteData(string experment_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Experment_Login  where experment_name ='" + experment_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }
}