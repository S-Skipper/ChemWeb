/**********************************************************
 * 数据操作层
 *********************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

/// <summary>
/// 连接chem_database数据库
/// </summary>
namespace chem_database.DAL
{
    /// <summary>
    /// Database类，用于数据连接和访问。
    /// </summary>
    public class Database
    {
        /// <summary>
        /// 保护变量，数据库连接。
        /// </summary>
        protected SqlConnection Connection;

        /// <summary>
        /// 保护变量，数据库连接串。
        /// </summary>
        protected String ConnectionString;

        /// <summary>
        /// 构造函数。
        /// </summary>
        /// <param name="DatabaseConnectionString">数据库连接串</param>
        public Database()
        {

            ConnectionString = "Persist Security Info=False;User=bds266769101;pwd=chem3668135;database=bds266769101_db;server=bds266769101.my3w.com";
        }

        /// <summary>
        /// 析构函数，关闭数据库
        /// </summary>
        ~Database()
        {
            try
            {
                if (Connection != null)
                    Connection.Close();
            }
            catch { }
        }

        /// <summary>
        /// 保护方法，打开数据库连接。
        /// </summary>
        protected void Open()
        {
            if (Connection == null)
            {
                Connection = new SqlConnection(ConnectionString);
            }
            if (Connection.State.Equals(ConnectionState.Closed))
            {
                Connection.Open();
            }
        }

        /// <summary>
        /// 公有方法，关闭数据库连接。
        /// </summary>
        public void Close()
        {
            if (Connection != null)
                Connection.Close();
        }

        /// <summary>
        /// 公有方法，获取数据，返回一个DataSet。
        /// </summary>
        /// <param name="SqlString">Sql语句</param>
        /// <returns>DataSet</returns>
        public DataSet GetDataSet(String SqlString)
        {
            Open();
            SqlDataAdapter adapter = new SqlDataAdapter(SqlString, Connection);
            DataSet dataSet = new DataSet();
            adapter.Fill(dataSet);
            Close();
            return dataSet;
        }
        /// <summary>
        /// 公有方法，获取数据，修改数据库数据，返回是否成功。
        /// </summary>
        /// <param name="Sql2">更新Sql语句</param>
        /// <returns>true</returns>
        public Boolean UpdateData(string Sql)
        {
            Open();
            SqlCommand myCom = new SqlCommand();
            myCom.Connection = Connection;
            myCom.CommandText = Sql;
            myCom.ExecuteNonQuery();
            Close();
            return true;
        }
        /// <summary>
        /// 公有方法，获取数据，判断是否表内有数据，返回是否有（主要用来判断是否存在该条记录）。
        /// </summary>
        /// <param name="Sql">更新Sql语句</param>
        /// <returns>true</returns>
        public Boolean CheckData(string Sql)
        {
            Open();
            SqlCommand myCom = new SqlCommand();
            myCom.Connection = Connection;
            myCom.CommandText = Sql;
            SqlDataReader sqlDataReader;

            sqlDataReader =myCom.ExecuteReader();
            if(sqlDataReader.Read())
            {
                Close();
                return true;
                
            }
            else
            {
                Close();
                return false;
            }
        }
      
    }
   

    }
