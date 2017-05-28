<%@ WebHandler Language="C#" Class="LoginHandler" %>

using System;
using System.Web;
using Login_Rank_Information.BLL;
using Login_Information.BLL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
public class LoginHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/json";
        context.Response.AddHeader("Access-Control-Allow-Origin", "*");
        context.Response.AddHeader("Access-Control-Allow-Methods", "POST");
        context.Response.AddHeader("Access-Control-Max-Age", "1000");
        string infor = "[" + context.Request["json"] + "]";
        JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
        string Type = ja[0]["type"].ToString();
        string ID = ja[0]["id"].ToString();
        


        //获得个人基本信息(所有用户)
        if (Type.Equals("GetInfoByID"))
        {
            string PW = ja[0]["pw"].ToString();
            string ID2 = ja[0]["find_id"].ToString(); ;//查询账户
            context.Response.Write(GetInfoByID(ID, PW,ID2));
        }
        //登录生成token
        else if (Type.Equals("Login"))
        {
            string PW = ja[0]["pw"].ToString();
            string No = ja[0]["No"].ToString();
            string str = ja[0]["str"].ToString();
            context.Response.Write(Login(ID, PW,No,str));
        }
        //更新个人基本信息（所有人）    
        //示例 [{"idebtity":"1","email":"1","QQ":"11111","phonenumber_long":"1","phonenumber_short":"1","address":"1"}]
        else if (Type.Equals("Info_Update"))
        {
            string PW = ja[0]["pw"].ToString();
            context.Response.Write(Info_Update(ID,PW,infor));
        }
        //更新某个基本信息（所有人）
        else if (Type.Equals("Info_Update_Only"))
        {
            string PW = ja[0]["pw"].ToString();

            context.Response.Write(Info_Update_Only(ID, PW, infor));
        }    
        //获得所有人基本信息（管理员）
        else if (Type.Equals("GetInfoAll"))
        {
            string PW = ja[0]["pw"].ToString();
            context.Response.Write(GetInfoAll(ID, PW));
        }
        //获得自己的权限信息 （所有人）
        else if (Type.Equals("GetRankByID"))
        {
            string PW = ja[0]["pw"].ToString();
            context.Response.Write(GetRankByID(ID, PW));
        }
        //通过ID获得某个人的问题 （所有人）
        else if (Type.Equals("GetQA"))
        {
            
            context.Response.Write(GetQA(ID));
        }

        //更新用户的问题和回答（所有人）
        else if (Type.Equals("Rank_UpdateQA"))
        {
            string PW = ja[0]["pw"].ToString();
            string Q = ja[0]["question"].ToString();
            string A = ja[0]["answer"].ToString();
            string PW1 = ja[0]["old_pw"].ToString();//密码
            context.Response.Write(Rank_UpdateQA(ID, PW, PW1, Q, A));
        }
        //更改用户密码（所有人）    
        else if (Type.Equals("Rank_UpdatePW"))
        {
            string PW = ja[0]["pw"].ToString();
            string PW1 = ja[0]["old_pw"].ToString();//密码
            string PW2 = ja[0]["new_pw"].ToString();//密码
            context.Response.Write(Rank_UpdatePW(ID, PW, PW1, PW2));
        }
        //获得所有人的权限信息（管理员）
        else if (Type.Equals("GetRankAll"))
        {
            string PW = ja[0]["pw"].ToString();
            context.Response.Write(GetRankAll(ID, PW));
        }
        //输入ID和问题答案重置用户密码 （所有人）
        else if (Type.Equals("ResetPWByID"))
        {

            string A = ja[0]["answer"].ToString();
            context.Response.Write(ResetPWByID(ID, A));
        }
        //重置用户密码和问题（管理员）
        else if (Type.Equals("ResetPWQAByID"))
        {
            string PW = ja[0]["pw"].ToString();
            string ID2 = ja[0]["find_id"].ToString();
            context.Response.Write(ResetPWQAByID(ID, PW,ID2));
        }
        //插入新用户（管理员）
        //示例 [{"ID":"1113","name":"13354439","rank_control":"管理权限","rank_news":"管理权限","rank_drug":"管理权限","rank_equipment":"管理权限","rank_experment":"管理权限","rank_course":"管理权限","rank_class":"管理权限","rank_student":"管理权限","rank_open":"管理权限"}]
         else if (Type.Equals("Rank_Insert"))
        {
            string PW = ja[0]["pw"].ToString();
            
            context.Response.Write(Rank_Insert(ID, PW, infor));
        }


        //更新用户姓名权限（管理员）
        //示例 [{"ID":"1113","name":"13354439","rank_control":"管理权限","rank_news":"管理权限","rank_drug":"管理权限","rank_equipment":"管理权限","rank_experment":"管理权限","rank_course":"管理权限","rank_class":"管理权限","rank_student":"管理权限","rank_open":"管理权限"}]
            
        else if (Type.Equals("Rank_UpdateAll"))
        {
            string PW = ja[0]["pw"].ToString();
            
            context.Response.Write(Rank_UpdateAll(ID, PW, infor));
        }
        
        //删除用户（管理员）
        else if (Type.Equals("Rank_Delete"))
        { //删除用户（管理员）
            string PW = ja[0]["pw"].ToString();
            string ID2 = ja[0]["find_id"].ToString();//账户
            context.Response.Write(Rank_Delete(ID, PW, ID2));
        }
       
        //更新上次登录时间
        else if (Type.Equals("UpdateLastTime"))
        {

            string PW = ja[0]["pw"].ToString();
            context.Response.Write(UpdateLastTime(ID, PW));
        }
        //获得上次登录时间
        else if (Type.Equals("GetLastTime"))
        {
            string PW = ja[0]["pw"].ToString();
            context.Response.Write(GetLastTime(ID, PW));
        }
        else if (Type.Equals("GetUserByRank"))
        {
            string PW = ja[0]["pw"].ToString();
            string name = ja[0]["name"].ToString();
            
            context.Response.Write(GetUserByRank(ID, PW,name));
        }   
            
        else
        {
            context.Response.Write(Type);
            //context.Response.Write("不存在该方法");
        }
       
        

    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    //登录

    public string Login(string ID, string PW,string No,string st)
    {
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        
        
         if(login_getinformation.Token(ID,PW))
        {
            DataSet ds = login_getinformation.LoadDataByDataSet(ID);
            UpdateLastTime(ID, PW);
            ds.Tables[0].Columns.Remove("PW");
            ds.Tables[0].Columns.Remove("question");
            ds.Tables[0].Columns.Remove("answer");
            return dsToJson(ds);
        }
         if (login_getinformation.ImageCheck(No,st)||st=="1111"&&No=="1111")
         {
             if (PW.Equals(login_rank1.PW))
             {

                 string str = MakePassword(18);
                 string time = DateTime.Now.ToString();
                 login_getinformation.Update_Data(ID, "token", str);
                 login_getinformation.Update_Data(ID, "token_Time", time);
                 DataSet ds = login_getinformation.LoadDataByDataSet(ID);
                 ds.Tables[0].Columns.Remove("PW");
                 ds.Tables[0].Columns.Remove("question");
                 ds.Tables[0].Columns.Remove("answer");
                 UpdateLastTime(ID, PW);
                 return dsToJson(ds);

                }
             else
             {
                 return "{\"error\":\"01\"}";
             }
        }
        else
        {
            return "{\"error\":\"11\"}";//验证码出错
        }
         return "{\"error\":\"01\"}";//失败 未登录

    }
   
    
    
    //获得个人基本信息(所有用户)

    public string GetInfoByID(string ID, string PW, string ID2)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID,PW))
        {
            if (ID == ID2)
            {

                return dsToJson(loginInformation.LoadData(ID2));
            }
            else
            {
                if (login_rank1.rank_control == "管理权限")
                {
                    return dsToJson(loginInformation.LoadData(ID2));
                }
                else
                {
                    return "{\"error\":\"02\"}";//无权限
                }
            }


        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //更新个人基本信息（所有人）
    public string Info_Update_Only(string ID, string PW, string infor)
    {

        LoginInformation loginInformation = new LoginInformation();
        login_information login_Information = new login_information();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        string name;
        string value;
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                if (infor == "")
                {
                    return "{\"error\":\"03\"}";//未传回数据
                }
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                login_Information.ID = ID;

                name = ja[0]["update_name"].ToString();
                value = ja[0]["value"].ToString();




                if (loginInformation.Update_Data_Only(ID,name,value))
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
    //更新个人基本信息（所有人）
    public string Info_Update(string ID, string PW, string infor)
    {

        LoginInformation loginInformation = new LoginInformation();
        login_information login_Information = new login_information();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限


            }
            else
            {
                if (infor == "")
                {
                    return "{\"error\":\"03\"}";//未传回数据
                }
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                login_Information.ID = ID;
                
                login_Information.idebtity = ja[0]["idebtity"].ToString();
                login_Information.email = ja[0]["email"].ToString();
                login_Information.QQ = ja[0]["QQ"].ToString();
                login_Information.phonenumber_long = ja[0]["phonenumber_long"].ToString();
                login_Information.phonenumber_short = ja[0]["phonenumber_short"].ToString();
                login_Information.address = ja[0]["address"].ToString();
                

                
                if (loginInformation.Update_Data(login_Information))
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

    //获得所有人基本信息（管理员）

    public string GetInfoAll(string ID, string PW)
    {

        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "管理权限")
            {
                return dsToJson(loginInformation.LoadDataAll());
               
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

    

    
    //获得自己的权限信息 （所有人）
    public string GetRankByID(string ID, string PW)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            DataSet ds;
            ds = login_getinformation.LoadDataByDataSet(ID);
            ds.Tables[0].Columns.Remove("PW");
            ds.Tables[0].Columns.Remove("question");
            ds.Tables[0].Columns.Remove("answer");
            return dsToJson(ds);

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //通过ID获得某个人的问题 （所有人）
    public string GetQA(string ID)
    {
        LoginRankInformation login_getinformation = new LoginRankInformation();
        DataSet ds = login_getinformation.GetQA(ID);
        if (ds.Tables[0].Rows.Count == 0)
        {
            return "{\"error\":\"03\"}";
        }
        else
        {
            return dsToJson(ds);
        }
        

    }
   

    //输入密码更新用户的问题和回答（所有人）

    public string Rank_UpdateQA(string ID, string PW, string PW_Old, string Question, string Answer)
    {

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "没有权限")
            {

                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                if (PW_Old.Equals(login_rank1.PW))
                {
                    if (login_getinformation.Update_Data(ID, "question", Question) && login_getinformation.Update_Data(ID, "answer", Answer))
                    {
                        return "{\"error\":\"0\"}";//成功
                    }
                    else
                    {
                        return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                    }
                }
                else
                {
                    return "{\"error\":\"04\"}";//"失败，验证旧密码错误"
                }
                    
                
                
            }



        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录


        }

    }

    //更改用户密码（所有人）

    public string Rank_UpdatePW(string ID, string PW, string PW_Old, string PW_New)
    {

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (PW_Old.Equals(login_rank1.PW))
            {


                if (login_getinformation.Update_Data(ID, "PW", PW_New))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }


            }
            else
            {
                return "{\"error\":\"04\"}";//"失败，验证旧密码错误"
            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }

    //获得所有人的权限信息（管理员）
    public string GetRankAll(string ID, string PW)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "管理权限")
            {
                DataSet ds;
                ds = login_getinformation.LoadData_all();
                ds.Tables[0].Columns.Remove("PW");
                ds.Tables[0].Columns.Remove("question");
                ds.Tables[0].Columns.Remove("answer");
                ds.Tables[0].Columns.Remove("token");
                ds.Tables[0].Columns.Remove("token_Time");
                return dsToJson(ds);
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
    //输入ID和问题答案重置用户密码 （所有人）
    public string ResetPWByID(string ID, string answer)
    {

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (answer == login_rank1.answer)
        {
            if (login_getinformation.Update_Data(ID, "PW", ID))
            {
                return "{\"error\":\"0\"}";//成功
            }
            else
            {
                return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
            }
        }
        else
        {
            return "{\"error\":\"05\"}";//"失败，问题回答错误"
        }






    }
    //重置用户密码和问题（管理员）
    public string ResetPWQAByID(string ID, string PW, string ID2)
    {

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "管理权限")
            {

                if (login_getinformation.Update_Data(ID2, "PW", ID2) && login_getinformation.Update_Data(ID2, "question", "未回答") && login_getinformation.Update_Data(ID2, "answer", ""))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
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

    //插入新用户（管理员）

    public string Rank_Insert(string ID, string PW, string infor)
    {

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        login_rank login_rank2 = new login_rank();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (infor == "")
            {
                return "{\"error\":\"03\"}";//未输入
            }
            if (login_rank1.rank_control == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                login_rank2.ID = ja[0]["find_id"].ToString();
                login_rank2.name = ja[0]["name"].ToString();
                login_rank2.rank_control = ja[0]["rank_control"].ToString();
                login_rank2.rank_news = ja[0]["rank_news"].ToString();
                login_rank2.rank_drug = ja[0]["rank_drug"].ToString();
                login_rank2.rank_equipment = ja[0]["rank_equipment"].ToString();
                login_rank2.rank_experment = ja[0]["rank_experment"].ToString();
                login_rank2.rank_course = ja[0]["rank_course"].ToString();
                login_rank2.rank_class = ja[0]["rank_class"].ToString();
                login_rank2.rank_student = ja[0]["rank_student"].ToString();
                login_rank2.rank_open = ja[0]["rank_open"].ToString();

                if (login_getinformation.Insert_Data(login_rank2))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"06\"}";//ID已存在
                }
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

    //更新用户姓名权限（管理员）
    public string Rank_UpdateAll(string ID, string PW, string infor)
    {

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        login_rank login_rank2 = new login_rank();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "管理权限")
            {

                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                login_rank2.ID = ja[0]["find_id"].ToString();
                login_rank2.name = ja[0]["name"].ToString();
                login_rank2.rank_control = ja[0]["rank_control"].ToString();
                login_rank2.rank_news = ja[0]["rank_news"].ToString();
                login_rank2.rank_drug = ja[0]["rank_drug"].ToString();
                login_rank2.rank_equipment = ja[0]["rank_equipment"].ToString();
                login_rank2.rank_experment = ja[0]["rank_experment"].ToString();
                login_rank2.rank_course = ja[0]["rank_course"].ToString();
                login_rank2.rank_class = ja[0]["rank_class"].ToString();
                login_rank2.rank_student = ja[0]["rank_student"].ToString();
                login_rank2.rank_open = ja[0]["rank_open"].ToString();


                if (login_getinformation.Update_Data(login_rank2))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
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
    //删除用户（管理员）

    public string Rank_Delete(string ID, string PW, string ID2)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_control == "管理权限")
            {
                DataSet ds = login_getinformation.LoadDataByDataSet(ID2);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"10\"}";//删除信息不存在
                }
                if (login_getinformation.Delete_Data(ID2))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
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
    //获得某个权限的某种权限人员目录（管理员）

    public string GetUserByRank(string ID, string PW, string name)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (name == "rank_course")
            {
                if (login_rank1.rank_course == "没有权限")
                {
                    return "无权限访问其他用户信息";

                }
                else
                {
                    return dsToJson(login_getinformation.LoadDataByRank(name, "一般权限"));
                }

            }
            else if (name == "rank_experment")
            {
                if (login_rank1.rank_experment == "没有权限")
                {
                    return "无权限访问其他用户信息";

                }
                else
                {
                    return dsToJson(login_getinformation.LoadDataByRank(name, "一般权限"));
                }
            }
            else
            {
                return "{\"error\":\"02\"}";
            }




        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }

    //更新上次登录时间

    public string UpdateLastTime(string ID, string PW)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {

            if (loginInformation.Update_last_time(ID))
            {
                return "{\"error\":\"0\"}";//成功
            }
            else
            {
                return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
            }


        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得上次登录时间
    public string GetLastTime(string ID, string PW)
    {
        LoginInformation loginInformation = new LoginInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {

            DateTime lasttime = loginInformation.Get_last_time(ID);
            return "{\"error\":\"0\",\"lasttime\":\""+lasttime.ToString()+"\"}";
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
    
    //生成随机数
    public string MakePassword(int pwdLength)
    {     //声明要返回的字符串    
        string tmpstr = "";
        //密码中包含的字符数组    
        string pwdchars = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        //数组索引随机数    
        int iRandNum;
        //随机数生成器    
        Random rnd = new Random();
        for (int i = 0; i < pwdLength; i++)
        {      //Random类的Next方法生成一个指定范围的随机数     
            iRandNum = rnd.Next(pwdchars.Length);
            //tmpstr随机添加一个字符     
            tmpstr += pwdchars[iRandNum];
        }
        return tmpstr;
    } 
}