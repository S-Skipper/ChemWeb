using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data;
namespace Drug.BLL
{

    /// <summary>
    /// DrugInfo类 drug_information表相关函数
    /// </summary>
    ///
    public class DrugInfo
    {
        public DrugInfo()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        /// <summary>
        /// 通过药品名称等一系列数据查找某些药品 返回dataset数据
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet LoadData(string search)
        {
            string sql;
            sql = "SELECT drug_name,drug_another_name,fen_zi_shi,counting,standard FROM Drug_Information WHERE drug_name LIKE '%" + search
                                                                                    + "%' OR drug_another_name LIKE '%" + search
                                                                                    + "%' OR fen_zi_shi LIKE '%" + search
                                                                                    + "%' OR CAS LIKE '%" + search + "%'" ;




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        /// <summary>
        /// 通过药品名称等一系列数据查找某些药品 返回dataset数据
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet LoadData_NoRank(string search)
        {
            string sql;
            sql = "SELECT drug_name,drug_another_name,fen_zi_shi FROM Drug_Information WHERE drug_name LIKE '%" + search
                                                                                    + "%' OR drug_another_name LIKE '%" + search
                                                                                    + "%' OR fen_zi_shi LIKE '%" + search
                                                                                    + "%' OR CAS LIKE '%" + search + "%'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        /// <summary>
        ///  返回所有药品dataset数据
        /// </summary>

        ///
        public DataSet LoadDataAll()
        {
            string sql;
            sql = "SELECT * FROM Drug_Information";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
         /// <summary>
        /// 通过药品名称及查询类型查找某药品，适用于未登录及无权限用户
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet FindData_NoRank(string search)
        {
            string sql;
            sql = "SELECT drug_name,drug_another_name,drug_Englishname,fen_zi_shi,fen_zi_liang,CAS,details,dangerous FROM Drug_Information WHERE drug_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }

        /// 通过药品名称及查询类型查找某药品，适用于具有管理权限及一般权限用户查看
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT * FROM Drug_Information WHERE drug_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }

        /// <summary>
        /// 通过药品名称更新某药品 返回true
        /// </summary>
        /// <param name="Drug_information">Drug_Information数据类</param>
        ///
        public Boolean Add_UpdateData(Drug_Information Drug_information ,string drug_name)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类
            if (db.CheckData("SELECT drug_name FROM Drug_Information WHERE drug_name = '" + drug_name + "'"))
            {
                sql = "UPDATE  Drug_Information SET  drug_name = '" + Drug_information.drug_name +
                                                "' ,drug_another_name = '" + Drug_information.drug_another_name +
                                                "' , drug_Englishname = '" + Drug_information.drug_Englishname +
                                                "' , fen_zi_shi = '" + Drug_information.fen_zi_shi +
                                                "' , fen_zi_liang = ' " + Drug_information.fen_zi_liang +
                                                "' , CAS = ' " + Drug_information.CAS +
                                                "' , details = ' " + Drug_information.details +
                                                "' , dangerous = ' " + Drug_information.dangerous +
                                                "' , standard = ' " + Drug_information.standard +
                                                "' , people = ' " + Drug_information.people +
                                                 "' , edit_time = ' " + DateTime.Now +
                                                " ' where drug_name ='" + drug_name + "'";

            }

            else
            {
                sql = "Insert into Drug_Information(drug_name,drug_another_name,drug_Englishname,fen_zi_shi,fen_zi_liang,CAS,details,dangerous,"
                                                + "counting,standard,people,edit_time) Values('"
                                                + Drug_information.drug_name + "','"
                                                + Drug_information.drug_another_name + "','"
                                                + Drug_information.drug_Englishname + "','"
                                                + Drug_information.fen_zi_shi + "','"
                                                + Drug_information.fen_zi_liang + "','"
                                                + Drug_information.CAS + "','"
                                                + Drug_information.details + "','"
                                                + Drug_information.dangerous + "','"
                                                + Drug_information.counting + "','"
                                                + Drug_information.standard + "','"
                                                + Drug_information.people + "','"
                                                +  DateTime.Now + "')";
            }


            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 通过药品名修改数量 返回true
        /// </summary>
        /// <param name="Drug_information">Drug_Information数据类</param>
        ///
        public Boolean Change(string drug_name,string type,double change)
        {
            string sql;
            DataSet dataset = new DataSet();
            Database db = new Database();		//实例化一个Database类
            double counting;
            if (db.CheckData("SELECT drug_name FROM Drug_Information WHERE drug_name = '" + drug_name + "'"))
            {
                sql = "SELECT counting FROM Drug_Information WHERE drug_name = '" + drug_name + "'";


                dataset = db.GetDataSet(sql);
                if (dataset.Tables[0].Rows.Count > 0)
                {
                    //从数据库中取值（数据库改变后需要在这里添加新的变量）
                    counting = (double)dataset.Tables[0].Rows[0]["counting"];


                }
                else
                {
                    return false;
                }

                if (type == "存")
                    counting = counting + change;
                else
                    counting = counting - change;


                sql = "UPDATE  Drug_Information SET  counting = '" + counting.ToString() +
                                                     "' , edit_time = ' " + DateTime.Now +
                                                    " ' where drug_name ='" + drug_name + "'";

            }

            else
            {
                return false;
            }


            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 删除某个药品
        /// <param name="drug_name">药品名</param>
        /// </summary>
        public Boolean DeleteData(string drug_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Drug_Information  where drug_name ='" + drug_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 获得某个药品的单位
        /// <param name="drug_name">药品名</param>
        /// </summary>
        public string GetStandard(string drug_name)
        {
            string sql;
            sql = "SELECT standard FROM Drug_Information WHERE drug_name = '" + drug_name + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            if (dataset.Tables[0].Rows.Count > 0)
            {
                return dataset.Tables[0].Rows[0]["standard"].ToString().Trim();
               
            }
            else
            {
                return "";
            }
        }

        /// <summary>
        /// 判断药品名存不存在
        /// <param name="drug_name">药品名</param>
        /// </summary>
        public Boolean IsDrug_name(string drug_name)
        {
            Database db = new Database();		
            //实例化一个Database类
            if (db.CheckData("SELECT drug_name FROM Drug_Information WHERE drug_name = '" + drug_name + "'"))
                return true;

            return false;
        }

    }
    /// <summary>
    /// Drug_Loc类 Drug_Loc表相关函数
    /// </summary>
    ///
    public class DrugLoc
    {
        public DrugLoc()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// 通过药品名称查询查找药品存量
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT * FROM Drug_Loc WHERE drug_name = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// 通过药品id查询具体情况
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet FindDataDetail(string search)
        {
            string sql;
            sql = "SELECT * FROM Drug_Loc WHERE id = '" + search + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 通过药品名称更新某药品存量 返回true
        /// </summary>
        /// <param name="drug_Loc">Drug_Loc数据类</param>
        ///
        public Boolean Add_UpdateData(Drug_Loc drug_Loc)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类


            if (drug_Loc.id == -1)
            {
                    sql = "Insert into Drug_Loc(drug_name,position,counting,remain,each,standard,people,edit_time) Values('"
                                                + drug_Loc.drug_name + "','"
                                                + drug_Loc.position + "','"
                                                + drug_Loc.counting + "','"
                                                + drug_Loc.remain + "','"
                                                + drug_Loc.each + "','"
                                                + drug_Loc.standard + "','"
                                                + drug_Loc.people + "','"
                                                + drug_Loc.edit_time + "')";
            }
            else
            {
                sql = "UPDATE  Drug_Loc SET  drug_name = '" + drug_Loc.drug_name +
                                               "' ,position = '" + drug_Loc.position +
                                               "' , counting = '" + drug_Loc.counting +
                                               "' , remain = ' " + drug_Loc.remain +
                                               "' , each = ' " + drug_Loc.each +
                                               "' , standard = ' " + drug_Loc.standard +
                                               "' , people = ' " + drug_Loc.people +
                                                "' , edit_time = ' " + DateTime.Now +
                                               " ' where id ='" + drug_Loc.id + "'";
            }



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 通过药品名称更新某药品单位 返回true
        /// </summary>
   
        ///
        public Boolean UpdateStandard(string drug_name,string standard)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类

            sql = "UPDATE  Drug_Loc SET  standard = '" + standard +
                                               " ' where drug_name ='" + drug_name + "'";
            



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个药品位置
        /// <param name="id">id</param>
        /// </summary>
        public Boolean DeleteData(string id)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Drug_Loc  where id ='" + id + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 数量
        /// <param name="id">id</param>
        /// </summary>
        public double Change(int id)
        {
            double change = 0;
            string sql;
            sql = "SELECT * FROM Drug_Loc WHERE id = '" + id + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            Drug_Loc drug_loc = new Drug_Loc();

            if (dataset.Tables[0].Rows.Count > 0)
            {
                //从数据库中取值（数据库改变后需要在这里添加新的变量）
                drug_loc.counting = Convert.ToInt32(dataset.Tables[0].Rows[0]["counting"]);
                drug_loc.each = Convert.ToDouble(dataset.Tables[0].Rows[0]["each"]);
                drug_loc.remain = Convert.ToDouble(dataset.Tables[0].Rows[0]["remain"]);
            }
            else
            {
                drug_loc.counting = 0;
                drug_loc.each = 0;
                drug_loc.remain = 0;
            }
            change = drug_loc.counting*1.0 ;
            change = change * (double)drug_loc.each + drug_loc.remain;
            return change;
        }

        /// <summary>
        /// 位置
        /// <param name="id">id</param>
        /// </summary>
        public string Positon(int id)
        {
          
            string sql;
            sql = "SELECT * FROM Drug_Loc WHERE id = '" + id + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);
            Drug_Loc drug_loc = new Drug_Loc();

            if (dataset.Tables[0].Rows.Count > 0)
            {
                //从数据库中取值（数据库改变后需要在这里添加新的变量）
                drug_loc.position = dataset.Tables[0].Rows[0]["position"].ToString().Trim();
                
            }
            else
            {
                drug_loc.position = "";
            }

            return drug_loc.position;
        }
    }

    public class DrugInOut
    {
        public DrugInOut()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 插入某个药品的出入库记录
        /// <param name="drug_name">药品记录</param>
        /// </summary>
        public Boolean InsertData(Drug_In_Out drug_In_Out)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Insert into Drug_In_Out(drug_name,change,people,standard,type,position,time) Values('"
                                                + drug_In_Out.drug_name + "','"
                                                + drug_In_Out.change + "','"
                                                + drug_In_Out.people + "','"
                                                + drug_In_Out.standard + "','"
                                                + drug_In_Out.type + "','"
                                                + drug_In_Out.position + "','"
                                                + DateTime.Now + "')";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 通过药品名称查记录
        /// <param name="drug_name">药品记录</param> 
        /// <param name="time1">开始时间</param> 
        /// <param name="time2">终止时间</param> 
        /// </summary>
        public DataSet FindDataByName(string search, string time1, string time2)
        {
            time2 +=" 23:59:59";
            //DateTime t = Convert.ToDateTime(time2);

            //t.AddDays(1);
            //t.ToString("yyyy-MM-dd");
            string sql;
            sql = "SELECT * FROM Drug_In_Out WHERE drug_name LIKE '%" + search + "%' and time between '" + time1 + "' and '" + time2 + "'";
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
    }
    /// Drug_Mix类 Drug_Mix表相关函数
    /// </summary>
    ///
    public class DrugMix
    {
        public DrugMix()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 通过试剂名称模糊查找试剂 返回dataset数据
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet LoadData(string search)
        {
            string sql;
            sql = "SELECT * FROM Drug_Mix WHERE drug_mix LIKE '%" + search+"%'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        /// <summary>
        /// 通过试剂名称查找试剂 返回dataset数据
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet LoadDataByName(string search)
        {
            string sql;
            sql = "SELECT * FROM Drug_Mix WHERE drug_mix = '" + search + "'";


            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        /// <summary>
        /// 通过试剂名称更新某试剂 返回true
        /// </summary>
        /// <param name="drug_Mix">drug_Mix数据类</param>
        ///
        public Boolean Add_UpdateData(Drug_Mix drug_Mix,string drug_mix)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类
            if (db.CheckData("SELECT drug_mix FROM Drug_Mix WHERE drug_mix = '" + drug_mix + "'"))
            {
                sql = "UPDATE  Drug_Mix SET  drug_mix = '" + drug_Mix.drug_mix +
                                                "' ,attention = '" + drug_Mix.attention +
                                                 "' ,standard = '" + drug_Mix.standard +
                                                " ' where drug_mix ='" + drug_mix + "'";

            }

            else
            {
                sql = "Insert into Drug_Mix(drug_mix,standard,attention) Values('"
                                                + drug_Mix.drug_mix + "','"
                                                  + drug_Mix.standard + "','"
                                                + drug_Mix.attention + "')";
            }


            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个试剂
        /// <param name="drug_name">试剂</param>
        /// </summary>
        public Boolean DeleteData(string drug_mix)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Drug_Mix  where drug_mix ='" + drug_mix + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 判断试剂名存不存在
        /// <param name="drug_name">试剂名</param>
        /// </summary>
        public Boolean IsDrug_Mix(string drug_mix)
        {
            Database db = new Database();
            //实例化一个Database类
            if (db.CheckData("SELECT drug_mix FROM Drug_Mix WHERE drug_mix = '" + drug_mix + "'"))
                return true;

            return false;
        }
    }
    /// <summary>
    /// Drug_Mix_Drug类 drug_mixdrug表相关函数
    /// </summary>
    ///
    public class DrugMixDrug
    {
        public DrugMixDrug()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// 通过试剂名称查询查找试剂配方
        /// </summary>
        /// <param name="search">search</param>
        ///
        public DataSet FindData(string search)
        {
            string sql;
            sql = "SELECT a.drug_mix ,a.drug_name ,a.num,a.standard,b.counting FROM Drug_MixDrug as a join Drug_Information as b on a.drug_name =b.drug_name where drug_mix = '" + search + "'" ;
            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);

            return dataset;
        }
        /// <summary>
        /// 通过试剂名称更新某药品 返回true
        /// </summary>
        /// <param name="Drug_information">Drug_Information数据类</param>
        ///
        public Boolean Add_UpdateData(Drug_MixDrug drug_MixDrug)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类


            sql = "Insert into Drug_MixDrug(drug_mix,drug_name,num,standard) Values('"
                                                + drug_MixDrug.drug_mix + "','"
                                                + drug_MixDrug.drug_name + "','"
                                                 + drug_MixDrug.num + "','"
                                                + drug_MixDrug.standard + "')";



            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除某个药品
        /// <param name="drug_name">药品名</param>
        /// </summary>
        public Boolean DeleteData(string drug_mix)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Drug_MixDrug  where drug_mix ='" + drug_mix + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }
}
