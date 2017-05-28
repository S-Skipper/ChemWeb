<%@ WebHandler Language="C#" Class="StudentHandler" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Login_Rank_Information.BLL;
using Login_Information.BLL;
using Student.BLL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class StudentHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";
        context.Response.AddHeader("Access-Control-Allow-Origin", "*");
        context.Response.AddHeader("Access-Control-Allow-Methods", "POST");
        context.Response.AddHeader("Access-Control-Max-Age", "1000");
        string infor = "[" + context.Request["json"] + "]";
        JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
        string Type = ja[0]["type"].ToString();
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();



        if (Type.Equals("GetInfoALL"))
        {
            
            context.Response.Write(GetInfoALL(ID, PW));
        }

        else if (Type.Equals("GetInfoByID"))
        {
            string ID2 = ja[0]["find_id"].ToString(); ;//查询账户
            context.Response.Write(GetInfoByID(ID, PW,ID2));
        }
              
        else if (Type.Equals("GetState"))
        {
            string ID2 = ja[0]["find_id"].ToString(); ;//查询账户
            context.Response.Write(GetState(ID, PW, ID2));
        }
      
        //获得所有人基本信息（管理员）
        else if (Type.Equals("ChangeState"))
        {
 
            context.Response.Write(ChangeState(ID, PW));
        }
      
        else if (Type.Equals("GetFreeTimeByID"))
        {
            string ID2 = ja[0]["find_id"].ToString(); ;//查询账户
            context.Response.Write(GetFreeTimeByID(ID, PW, ID2));
        }
        else if (Type.Equals("GetFreeTimeBTime_type"))
        {
            string time_type = ja[0]["time_type"].ToString(); ;//查询账户
            context.Response.Write(GetFreeTimeBTime_type(ID, PW, time_type));
        }
        else if (Type.Equals("GetFreeTimeBTime_typeOnly"))
        {
            string time_type = ja[0]["time_type"].ToString(); ;//查询账户
            string time1 = ja[0]["from"].ToString();
            context.Response.Write(GetFreeTimeBTime_typeOnly(ID, PW, time_type, time1));
        }
        else if (Type.Equals("FreeTime_Insert"))
        {
            string[] sArray = infor.Split('[');
            string[] infor1 = sArray[2].ToString().Split(']');

            if (infor1[0] != "")
                infor1[0] = "[" + infor1[0] + "]";
            context.Response.Write(FreeTime_Insert(ID, PW, infor1[0]));
        }
   
        else if (Type.Equals("FreeTime_Delete"))
        {
            context.Response.Write(FreeTime_Delete(ID, PW));
        }

        else if (Type.Equals("GetWorkInfo"))
        {
            string time1 = ja[0]["from"].ToString();
            string time2 = ja[0]["to"].ToString(); 
            context.Response.Write(GetWorkInfo(ID, PW,time1,time2));
        }

        else if (Type.Equals("GetWorkInfoByID"))
        {
            string ID2 = ja[0]["find_id"].ToString(); ;//查询账户
            string time1 = ja[0]["from"].ToString();
            string time2 = ja[0]["to"].ToString();
            context.Response.Write(GetWorkInfoByID(ID, PW, ID2, time1, time2));
        }

        else if (Type.Equals("WorkTime_Insert"))
        {
            string[] sArray = infor.Split('[');
            string[] infor1 = sArray[2].ToString().Split(']');

            if (infor1[0] != "")
                infor1[0] = "[" + infor1[0] + "]";
            context.Response.Write(WorkTime_Insert(ID, PW, infor1[0]));
        }
        else if (Type.Equals("WorkTime_DeleteByDate_time"))
        {
            string date_time = ja[0]["from"].ToString(); ;//查询账户

            context.Response.Write(WorkTime_DeleteByDate_time(ID, PW, date_time));
        }



      
        else if (Type.Equals("WorkTime_DeleteByTime_id"))
        {

            string time_id = ja[0]["time_id"].ToString(); ;//查询账户
            context.Response.Write(WorkTime_DeleteByTime_id(ID, PW, time_id));
        }

        else if (Type.Equals("GetSignInfo"))
        { 
            string time1 = ja[0]["from"].ToString();
            string time2 = ja[0]["to"].ToString();
            context.Response.Write(GetSignInfo(ID, PW,time1,time2));
        }

        else if (Type.Equals("GetSignInfoByID"))
        {
            string time1 = ja[0]["from"].ToString();
            string time2 = ja[0]["to"].ToString();
            string ID2 = ja[0]["find_id"].ToString();//账户
            context.Response.Write(GetSignInfoByID(ID, PW, ID2,time1, time2));
        }
        
        else
        {
            context.Response.Write(Type);
            //context.Response.Write("不存在该方法");
        }



    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    //获得所有人的基本信息


    public string GetInfoALL(string ID, string PW)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                return dsToJson(studentInfo.LoadDataAll());
            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得某人的信息

    public string GetInfoByID(string ID, string PW, string ID2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                DataSet ds = studentInfo.LoadDataByID(ID2);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"03\"}";//无数据查到
                }
                else
                    return dsToJson(ds);
            }
           

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得某人的签到信息

    public string GetState(string ID, string PW, string ID2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                DataSet ds = studentInfo.State(ID2);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"0\",\"data\":[{\"last_time\":\"1900/0/0 00:00:01\",\"state\":\"未签到过\"}]}";//无数据查到
                    
                }
                else
                    return dsToJson(ds);
            }


        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
   
   
    //更改签到状态

    public string ChangeState(string ID, string PW)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                if (studentInfo.Change_State(ID))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
            }


        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
   
   

   
    


    //获得某人的空闲时间表

    public string GetFreeTimeByID(string ID, string PW, string ID2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentFreeTime StudentFreeTime1 = new StudentFreeTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                DataSet ds = StudentFreeTime1.LoadDataByID(ID2);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"0\",\"data\":[]}";
                }
                else
                    return dsToJson(ds);
            }


        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }

    public string GetFreeTimeBTime_typeOnly(string ID, string PW, string time_type, string date_time)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentFreeTime StudentFreeTime1 = new StudentFreeTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                DataSet ds = StudentFreeTime1.LoadDataByTime_TypeOnly(time_type,date_time);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"0\",\"data\":[]}";
                }
                else
                    return dsToJson(ds);
            }


        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    
    //获得某时段的空闲时间表

    
    
    public string GetFreeTimeBTime_type(string ID, string PW, string time_type)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentFreeTime StudentFreeTime1 = new StudentFreeTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                DataSet ds = StudentFreeTime1.LoadDataByTime_Type(time_type);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"0\",\"data\":[]}";
                }
                else
                    return dsToJson(ds);
            }


        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //插入空闲时间信息
    public string FreeTime_Insert(string ID, string PW, string infor)
    {

        LoginInformation loginInformation = new LoginInformation();
        login_information login_Information = new login_information();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        Student_Freetime student_Freetime = new Student_Freetime();
        StudentFreeTime StudentFreeTime1 = new StudentFreeTime();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {

            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                if (infor == "")
                {
                    return "{\"error\":\"04\"}";//未传回数据
                }

                StudentFreeTime1.DeleteData(ID);
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                for (int i = 0; i < ja.Count; i++)
                {
                    student_Freetime.ID = ja[i]["ID"].ToString();
                    student_Freetime.name = ja[i]["name"].ToString();
                    student_Freetime.time_type = Convert.ToInt32(ja[i]["time_type"]);





                    if (StudentFreeTime1.Insert_Data(student_Freetime))
                    {
                       
                    }
                  
                }
                return "{\"error\":\"0\"}";//成功
            }

        }

        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    public string FreeTime_Delete(string ID, string PW)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentFreeTime StudentFreeTime1 = new StudentFreeTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                if (StudentFreeTime1.DeleteData(ID))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
            }



        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }

    //获得所有人排班信息

    public string GetWorkInfo(string ID, string PW,     string time1, string time2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        
        StudentWorkTime StudentWorkTime1 = new StudentWorkTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
                

            }
            else
            {
                DataSet ds = StudentWorkTime1.FindAllDataByTime(time1, time2);
                if (ds.Tables[0].Rows.Count != 0)
                {
                    ds.Tables[0].Columns.Add("date", System.Type.GetType("System.String"));
                    for (int k = 0; k < ds.Tables[0].Rows.Count; k++)
                     {
                        DateTime dt = (System.DateTime)ds.Tables[0].Rows[k]["date_time"];
                         ds.Tables[0].Rows[k]["date"] = dt.ToString("yyyy-MM-dd");
                        
                     }
                    ds.Tables[0].Columns.Remove("date_time");
                }
                return dsToJson(ds);

            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得某人排班工时信息

    public string GetWorkInfoByID(string ID, string PW, string ID2, string time1, string time2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        StudentWorkTime StudentWorkTime1 = new StudentWorkTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限

            }
            else
            {
                DataSet ds = StudentWorkTime1.FindDataByID(ID2, time1, time2);
                if (ds.Tables[0].Rows.Count != 0)
                {
                    ds.Tables[0].Columns.Add("date", System.Type.GetType("System.String"));
                    for (int k = 0; k < ds.Tables[0].Rows.Count; k++)
                    {
                        DateTime dt = (System.DateTime)ds.Tables[0].Rows[k]["date_time"];
                        ds.Tables[0].Rows[k]["date"] = dt.ToString("yyyy-MM-dd");

                    }
                    ds.Tables[0].Columns.Remove("date_time");
                }
                return dsToJson(ds);
                


            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //插入排班信息
    public string WorkTime_Insert(string ID, string PW, string infor)
    {

        LoginInformation loginInformation = new LoginInformation();
        login_information login_Information = new login_information();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        Student_Worktime Student_Worktime1 = new Student_Worktime();
        StudentWorkTime StudentWorkTime1 = new StudentWorkTime();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {

            if (login_rank1.rank_student == "管理权限")
            {
                
                if (infor == "")
                {
                    return "{\"error\":\"04\"}";//未传回数据
                }


                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                for (int i = 0; i < ja.Count; i++)
                {
                    Student_Worktime1.ID = ja[i]["ID"].ToString();
                    Student_Worktime1.name = ja[i]["name"].ToString();
                    Student_Worktime1.time_type = Convert.ToInt32(ja[i]["time_type"]);
                    Student_Worktime1.date_time = Convert.ToDateTime(ja[i]["date_time"]);




                    if (StudentWorkTime1.Insert_Data(Student_Worktime1))
                    {
                       
                    }
                    
                }
                return "{\"error\":\"0\"}";//成功
            }
            else
            {
                return "{\"error\":\"02\"}";//无权限
            }

        }

        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    public string WorkTime_DeleteByDate_time(string ID, string PW, string date_time)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentWorkTime StudentWorkTime1 = new StudentWorkTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                if (StudentWorkTime1.DeleteData(date_time))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
            }



        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    public string WorkTime_DeleteByTime_id(string ID, string PW, string time_id)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentWorkTime StudentWorkTime1 = new StudentWorkTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                if (StudentWorkTime1.DeleteDataByTimeid(time_id))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
            }



        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }

    //获得所有人签到信息

    public string GetSignInfo(string ID, string PW, string time1, string time2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        StudentSignTime StudentSignTime = new StudentSignTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "管理权限")
            {

                return dsToJson(StudentSignTime.FindDataAll( time1, time2));

            }
            else
            {
                return "{\"error\":\"02\"}";//无权限
               
            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得自己签到信息

    public string GetSignInfoByID(string ID, string PW,string ID2, string time1, string time2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        StudentInfo studentInfo = new StudentInfo();
        StudentSignTime StudentSignTime = new StudentSignTime();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_student == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
                
            }
            else if (login_rank1.rank_student == "一般权限")
            {
                if(ID2==ID)
                return dsToJson(StudentSignTime.FindDataByName(ID2, time1, time2));
                else
                {
                    return "{\"error\":\"02\"}";//无权限 
                }


            }
            else
            {
                return dsToJson(StudentSignTime.FindDataByName(ID2, time1, time2));
            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }



    private string dsToJson(DataSet ds)
    {
        string json = "{\"error\":\"0\",\"data\":[";
        try
        {
            if (ds.Tables.Count == 0)
                throw new Exception("DataSet中Tables为0");

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                json += "{";

                for (int k = 0; k < ds.Tables[0].Columns.Count; k++)
                {
                    json += "\"" + ds.Tables[0].Columns[k].ColumnName.ToString().Trim() + "\"" + ":\"" + ds.Tables[0].Rows[i][k].ToString().Trim() + "\"";

                    if (k < ds.Tables[0].Columns.Count - 1)
                    {
                        json += ",";
                    }
                }

                json += "}";
                if (i < ds.Tables[0].Rows.Count - 1)
                {
                    json += ",";
                }


            }

            json += "]";

            json += "}";

        }

        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
        return json;
    }  

}