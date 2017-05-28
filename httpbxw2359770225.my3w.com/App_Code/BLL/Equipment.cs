using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using chem_database.DAL;
using System.Data;
namespace Equipment.BLL
{
    /// <summary>
    /// Equipment_Information表相关函数
    /// </summary>
    public class EquipmentInfo
    {
        public EquipmentInfo()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        /// <summary>
        /// 通过仪器名称等查找某仪器 返回dataset数据
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet LoadData(string search)
        {
            string sql;
            sql = "SELECT * FROM Equipment_Information WHERE equip_name LIKE '%" + search
                                                    + "%' OR factory LIKE '%" + search + "%'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        public DataSet LoadDataDetail(string search)
        {
            string sql;
            sql = "SELECT * FROM Equipment_Information WHERE equip_name = '" + search+"'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        /// <summary>
        /// 通过仪器名称更新某仪器 返回true
        /// <param name="Drug_information">Drug_Information数据类</param> 
        /// <param name="equip_name">仪器名</param> 
        /// </summary>
        public Boolean Add_UpdateData(Equipment_Information equipment_Inf, string equip_name)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类
            
            if (equip_name!="-1")
            {
                if(db.CheckData("SELECT equip_name FROM Equipment_Information WHERE equip_name = '" + equip_name + "'"))
                    {

                        if (equip_name == equipment_Inf.equip_name)
                        {

                        }
                        else
                        {
                            if (db.CheckData("SELECT equip_name FROM Equipment_Information WHERE equip_name = '" + equipment_Inf.equip_name + "'"))
                            {
                                return false;
                            }
                        }
                    }
                    else
                    {
                        return false;
                    }

              
                
                sql = "UPDATE  Equipment_Information SET  equip_name = '" + equipment_Inf.equip_name +
                                                "' ,model = '" + equipment_Inf.model +
                                                "' , factory = '" + equipment_Inf.factory +
                                                "' , detail = '" + equipment_Inf.detail +
                                                "' , price = ' " + equipment_Inf.price +
                                                " ' where equip_name ='" + equip_name + "'";

            }

            else
            {
                if (db.CheckData("SELECT equip_name FROM Equipment_Information WHERE equip_name = '" + equipment_Inf.equip_name + "'") == false)
                sql = "Insert into Equipment_Information(equip_name,model,factory,detail,price) Values('"
                                                + equipment_Inf.equip_name + "','"
                                                + equipment_Inf.model + "','"
                                                + equipment_Inf.factory + "','"
                                                + equipment_Inf.detail + "','"

                                                + equipment_Inf.price + "')";
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
        /// 删除某个仪器
        /// <param name="equip_name">equip_name</param> 
        /// </summary>
        public Boolean DeleteData(string equip_name)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Equipment_Information  where equip_name ='" + equip_name + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }


    /// <summary>
    /// Equipment_Loc表 的相关函数
    /// </summary>
    public class EquipmentLoc
    {
        public EquipmentLoc()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        /// <summary>
        /// 通过仪器名称等查找某仪器 返回dataset数据
        /// </summary>
        /// <param name="search">search</param> 
        /// 
        public DataSet LoadData(string search)
        {
            string sql;
            sql = "SELECT * FROM Equipment_Loc WHERE equip_name LIKE '%" + search
                                                                                   + "%' OR position LIKE '%" + search
                                                                                    + "%' OR fixed_assets_NO ='" + search
                                                                                    + "' OR state ='" + search 
                                                                                    + "' OR factory_NO ='" + search + "'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        public DataSet LoadDataDetail(string search)
        {
            string sql;
            sql = "SELECT * FROM Equipment_Loc WHERE equip_name = '" + search + "'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }
        public DataSet LoadDataByNo(string search)
        {
            string sql;
            sql = "SELECT * FROM Equipment_Loc WHERE fixed_assets_NO = '" + search + "'";




            Database db = new Database();		//实例化一个Database类
            DataSet dataset = new DataSet();
            dataset = db.GetDataSet(sql);


            return dataset;
        }

        /// <summary>
        /// 通过仪器名称更新某仪器 返回true
        /// </summary>
        /// <param name="equipment_Loc">Equipment_Loc数据类</param> 
        ///  <param name="fixed_assets_NO">固定资产号</param> 
        public Boolean Update_Data(Equipment_Loc equipment_Loc, string fixed_assets_NO)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类
            if (db.CheckData("SELECT equip_name FROM Equipment_Loc WHERE fixed_assets_NO = '" + fixed_assets_NO + "'"))
            {
                if (fixed_assets_NO != equipment_Loc.fixed_assets_NO)
                {

                    if (db.CheckData("SELECT equip_name FROM Equipment_Loc WHERE fixed_assets_NO = '" + equipment_Loc.fixed_assets_NO + "'"))
                    {
                        return false;
                    }

                }

            }
            else
            {
                return false;
            }
             sql = "UPDATE  Equipment_Loc SET  equip_name = '" + equipment_Loc.equip_name +
                                                "' ,fixed_assets_NO = '" + equipment_Loc.fixed_assets_NO +
                                                "' , factory_NO = '" + equipment_Loc.factory_NO +
                                                "' , time_buying = '" + equipment_Loc.time_buying +
                                                "' , people = ' " + equipment_Loc.people +
                                                "' , position = ' " + equipment_Loc.position +
                                                "' , state = ' " + equipment_Loc.state +
                                                "' , state_explane = ' " + equipment_Loc.state_explane +
                                                "' , edit_time = ' " + DateTime.Now +
                                                " ' where fixed_assets_NO ='" + fixed_assets_NO + "'";

            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 通过仪器名称更新某仪器 返回true
        /// </summary>
        /// <param name="equipment_Loc">Equipment_Loc数据类</param> 
        public Boolean Add_Data(Equipment_Loc equipment_Loc)
        {
            string sql;
            Database db = new Database();		//实例化一个Database类
            if (db.CheckData("SELECT equip_name FROM Equipment_Loc WHERE fixed_assets_NO = '" + equipment_Loc.fixed_assets_NO + "'"))
            {
                return false;

            }

            else
            {
                sql = "Insert into Equipment_Loc(equip_name,fixed_assets_NO,factory_NO,time_buying,people,position,state,state_explane,edit_time) Values('"
                                                + equipment_Loc.equip_name + "','"
                                                + equipment_Loc.fixed_assets_NO + "','"
                                                + equipment_Loc.factory_NO + "','"
                                                + equipment_Loc.time_buying + "','"
                                                + equipment_Loc.people + "','"
                                                + equipment_Loc.position + "','"
                                                + equipment_Loc.state + "','"
                                                + equipment_Loc.state_explane + "','"
                                                + DateTime.Now + "')";
            }


            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 删除某个仪器
        ///  <param name="fixed_assets_NO">固定资产号</param> 
        /// </summary>
        public Boolean DeleteData(string fixed_assets_NO)
        {
            Database db = new Database();		//实例化一个Database类
            string sql = "Delete Equipment_Loc  where fixed_assets_NO ='" + fixed_assets_NO + "'";
            if (db.UpdateData(sql))
            {
                return true;
            }
            return false;
        }
    }
}