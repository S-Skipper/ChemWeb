<%@ WebHandler Language="C#" Class="ExperHandler" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Login_Rank_Information.BLL;
using Experment.BLL;
using Drug.BLL;
public class ExperHandler : IHttpHandler {
    
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

        //获得实验信息
        if (Type.Equals("GetExperience"))
        {
           
            string experment_name = ja[0]["experment_name"].ToString();

            context.Response.Write(GetExperience(ID, PW, experment_name));
        }
        else if (Type.Equals("FindExperience"))
        {

            string experment_name = ja[0]["experment_name"].ToString();

            context.Response.Write(FindExperience(ID, PW, experment_name));
        }
        //获得实验所需所有药品量及药品存量
        else if (Type.Equals("GetExp_AllDrug"))
        {
            string experment_name = ja[0]["experment_name"].ToString();

             context.Response.Write(GetExp_AllDrug(ID, PW, experment_name));
        }
        //获得实验对应药品
        else if (Type.Equals("GetExp_Drug"))
        {

            string experment_name = ja[0]["experment_name"].ToString();
            context.Response.Write(GetExp_Drug(ID, PW, experment_name));
        }
        //获得实验对应试剂
        else if (Type.Equals("GetExp_Mix"))
        {
            string experment_name = ja[0]["experment_name"].ToString();


            context.Response.Write(GetExp_Mix(ID, PW, experment_name));
        }
        //获得实验对应房间    
        else if (Type.Equals("GetExp_Room"))
        {

            string experment_name = ja[0]["experment_name"].ToString();
            context.Response.Write(GetExp_Room(ID, PW, experment_name));
        }
       
        else if (Type.Equals("Exper_Insert_Update"))
        {
            
            string[] sArray = infor.Split('[');
            string[] infor1 = sArray[2].ToString().Split(']');
            string[] infor2 = sArray[3].ToString().Split(']');
            string[] infor3 = sArray[4].ToString().Split(']');

            if (infor1[0] != "")
                infor1[0] = "[" + infor1[0] + "]";
            if (infor2[0] != "")
                infor2[0] = "[" + infor2[0] + "]";
            if (infor3[0] != "")
                infor3[0] = "[" + infor3[0] + "]";
            
            context.Response.Write(Exper_Insert_Update(ID, PW, infor, infor1[0], infor2[0], infor3[0]));
        }
          else if (Type.Equals("Exper_Delete"))
        {
            string experment_name = ja[0]["experment_name"].ToString();
            context.Response.Write(Exper_Delete(ID, PW, experment_name));
        }   
        else if (Type.Equals("GetRoom"))
        {

            context.Response.Write(GetRoom(ID, PW));
        }
        else if (Type.Equals("GetRoom_Exper"))
        {
            string room_name = ja[0]["room_name"].ToString();
            context.Response.Write(GetRoom_Exper(ID, PW, room_name));
        }
        else if (Type.Equals("Room_Insert_Update"))
        {
          
            context.Response.Write(Room_Insert_Update(ID, PW, infor));
        }
        else if (Type.Equals("Room_Delete"))
        {

            string room_name = ja[0]["room_name"].ToString();
            context.Response.Write(Room_Delete(ID, PW, room_name));
        }
        else if (Type.Equals("Exper_LoginByID"))
        {
            
            context.Response.Write(Exper_LoginByID(ID, PW));
        }
       
        else if (Type.Equals("Exper_LoginByName"))
        {
            string experment_name = ja[0]["experment_name"].ToString();
            context.Response.Write(Exper_LoginByName(ID, PW, experment_name));
        }
        else if (Type.Equals("Exper_LoginInsert_Update"))
        {
            string experment_name = ja[0]["experment_name"].ToString();
            string[] sArray = infor.Split('[');
            string[] infor1 = sArray[2].ToString().Split(']');
            

            if (infor1[0] != "")
                infor1[0] = "[" + infor1[0] + "]";
            //context.Response.Write(infor1[0]);
            context.Response.Write(Exper_LoginInsert_Update(ID, PW,infor1[0], experment_name));
        }   
        else
        {
            context.Response.Write(Type);
            
        }
    }




    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    //获得实验信息
    public string GetExperience(string ID, string PW, string infor)
    {

        ExpermentInfo expermentInfo = new ExpermentInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(expermentInfo.LoadData(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得实验信息
    public string FindExperience(string ID, string PW, string infor)
    {

        ExpermentInfo expermentInfo = new ExpermentInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                DataSet ds = expermentInfo.FindData(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"11\"}";//信息不存在
                }
                return dsToJson(ds);
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得实验所需所有药品量及药品存量
    public string GetExp_AllDrug(string ID, string PW, string infor)
    {
        //药品
        ExpermentDrug expermentDrug = new ExpermentDrug();
        DrugInfo drugInfo = new DrugInfo();
        //试剂
        ExpermentMixDrug expermentMixDrug = new ExpermentMixDrug();
        DrugMixDrug drugMixDrug = new DrugMixDrug();


        DataSet drug_mixdrugAll = new DataSet();
        DataTable dt = drug_mixdrugAll.Tables.Add("Table");
        dt.Columns.Add("drug_name", System.Type.GetType("System.String"));
        dt.Columns.Add("num", System.Type.GetType("System.Double"));

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                DataSet ds = new DataSet();
                ds = expermentDrug.FindData(infor);
                ds.Tables[0].Columns.Remove("experment_name");
                ds.Tables[0].Columns.Remove("standard");
                drug_mixdrugAll = DatasetToDataset(drug_mixdrugAll, ds);

                DataSet ds_mix = new DataSet();
                ds_mix = expermentMixDrug.FindData(infor);
                for (int i = 0; i < ds_mix.Tables[0].Rows.Count; i++)
                {
                    ds = drugMixDrug.FindData(ds_mix.Tables[0].Rows[i]["drug_mix"].ToString().Trim());
                    ds.Tables[0].Columns.Remove("standard");
                    for (int k = 0; k < ds.Tables[0].Rows.Count; k++)
                    {

                        ds.Tables[0].Rows[k]["num"] = (double)ds.Tables[0].Rows[k]["num"] * (double)ds_mix.Tables[0].Rows[i]["num"];
                    }
                    drug_mixdrugAll = DatasetToDataset(drug_mixdrugAll, ds);
                }

                drug_mixdrugAll.Tables[0].Columns.Add("counting", System.Type.GetType("System.Int32"));
                drug_mixdrugAll.Tables[0].Columns.Add("standard", System.Type.GetType("System.String"));
                for (int i = 0; i < drug_mixdrugAll.Tables[0].Rows.Count; i++)
                {
                    ds = drugInfo.FindData(drug_mixdrugAll.Tables[0].Rows[i]["drug_name"].ToString().Trim());
                    drug_mixdrugAll.Tables[0].Rows[i]["counting"] = ds.Tables[0].Rows[0]["counting"];
                    drug_mixdrugAll.Tables[0].Rows[i]["standard"] = ds.Tables[0].Rows[0]["standard"];

                }

                return dsToJson(drug_mixdrugAll);
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }
    }
    //获得实验对应药品
    public string GetExp_Drug(string ID, string PW, string infor)
    {
        ExpermentDrug expermentDrug = new ExpermentDrug();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(expermentDrug.FindData(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得实验对应试剂
    public string GetExp_Mix(string ID, string PW, string infor)
    {
        ExpermentMixDrug expermentMixDrug = new ExpermentMixDrug();

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(expermentMixDrug.FindData(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得实验对应房间
    public string GetExp_Room(string ID, string PW, string infor)
    {
        ExpermentRoom expermentRoom = new ExpermentRoom();

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(expermentRoom.FindData(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //实验信息及增改 experment_name为修改前的试剂名（用来定位记录）
    public string Exper_Insert_Update(string ID, string PW, string infor, string infor2, string infor3, string infor4)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        //实验基本情况
        Experment_Information experment_Information = new Experment_Information();
        ExpermentInfo expermentInfo = new ExpermentInfo();
        //实验对应药品配方
        Experment_Drug experment_Drug = new Experment_Drug();
        ExpermentDrug expermentDrug = new ExpermentDrug();
        //实验对应试剂
        Experment_MixDrug experment_MixDrug = new Experment_MixDrug();
        ExpermentMixDrug expermentMixDrug = new ExpermentMixDrug();
        //实验对应房间
        Experment_Room experment_Room = new Experment_Room();
        ExpermentRoom expermentRoom = new ExpermentRoom();

        ExpermentLogin expermentLogin = new ExpermentLogin();
        if (PW.Equals(login_rank1.PW))
        {
            JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
            experment_Information.experment_name = ja[0]["experment_name"].ToString();
            experment_Information.detail = ja[0]["detail"].ToString();
            experment_Information.error = (double)ja[0]["error"];
            string experment_name = ja[0]["experment_name_old"].ToString();
            
            if (login_rank1.rank_experment == "管理权限" || (login_rank1.rank_experment == "一般权限" && expermentLogin.Rank(experment_name, ID)))
            {
               


                if (expermentInfo.Add_UpdateData(experment_Information, experment_name))
                {


                    if (expermentDrug.DeleteData(experment_Information.experment_name))
                    {
                        if (infor2 == "")
                        {

                        }
                        else
                        {
                            JArray ja2 = (JArray)JsonConvert.DeserializeObject(infor2);
                            for (int i = 0; i < ja2.Count; i++)
                            {
                                experment_Drug.experment_name = experment_Information.experment_name;
                                experment_Drug.drug_name = ja2[i]["drug"].ToString();
                                experment_Drug.num = (int)ja2[i]["num"];
                                experment_Drug.standard = ja2[i]["standard"].ToString();
                                expermentDrug.Add_UpdateData(experment_Drug);
                            }
                        }



                    }
                    else
                    {
                        return "{\"error\":\"09\"}";//更新出错
                    }

                    if (expermentMixDrug.DeleteData(experment_Information.experment_name))
                    {
                        if (infor3 == "")
                        {

                        }
                        else
                        {
                            JArray ja3 = (JArray)JsonConvert.DeserializeObject(infor3);
                            for (int i = 0; i < ja3.Count; i++)
                            {
                                experment_MixDrug.experment_name = experment_Information.experment_name;
                                experment_MixDrug.drug_mix = ja3[i]["mix"].ToString();
                                experment_MixDrug.standard = ja3[i]["standard"].ToString();
                                experment_MixDrug.num = (int)ja3[i]["num"];
                                expermentMixDrug.Add_UpdateData(experment_MixDrug);
                            }
                        }



                    }
                    else
                    {
                        return "{\"error\":\"09\"}";//更新出错
                    }

                    if (expermentRoom.DeleteData(experment_Information.experment_name))
                    {
                        if (infor4 == "")
                        {

                        }
                        else
                        {
                            JArray ja3 = (JArray)JsonConvert.DeserializeObject(infor4);
                            for (int i = 0; i < ja3.Count; i++)
                            {
                                experment_Room.experment_name = experment_Information.experment_name;
                                experment_Room.room_name = ja3[i]["room_name"].ToString();

                                expermentRoom.Add_UpdateData(experment_Room);
                            }
                        }

                        return "{\"error\":\"0\"}";//成功

                    }
                    else
                    {
                        return "{\"error\":\"09\"}";//更新出错
                    }

                }
                else
                {
                    return "{\"error\":\"09\"}";//更新出错
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
    //实验删除
    public string Exper_Delete(string ID, string PW, string infor)
    {

        ExpermentInfo expermentInfo = new ExpermentInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "管理权限")
            {
                DataSet ds = expermentInfo.FindData(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"11\"}";//信息不存在
                }
                
                if (expermentInfo.DeleteData(infor))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"10\"}";//删除出错
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
    //获得房间信息
    public string GetRoom(string ID, string PW)
    {
        R_Room r_Room = new R_Room();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(r_Room.LoadData());
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得房间对应实验
    public string GetRoom_Exper(string ID, string PW, string infor)
    {

        ExpermentRoom expermentRoom = new ExpermentRoom();

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(expermentRoom.FindDataByRoom(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //房间信息修改 room_name为修改前的房间名（用来定位记录）
    public string Room_Insert_Update(string ID, string PW, string infor)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        //试剂基本情况
        Room room = new Room();
        R_Room r_Room = new R_Room();
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
                room.room_name = ja[0]["room_name"].ToString();
                room.detail = ja[0]["detail"].ToString();
                string room_name = ja[0]["room_name_old"].ToString();
                if (r_Room.Add_UpdateData(room, room_name))
                {
                    return "{\"error\":\"0\"}";//成功

                }
                else
                {
                    return "{\"error\":\"09\"}";//更新出错
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
    //房间删除
    public string Room_Delete(string ID, string PW, string infor)
    {

        R_Room r_Room = new R_Room();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "管理权限")
            {
                DataSet ds = r_Room.FindData(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"11\"}";//信息不存在
                }
                if (r_Room.DeleteData(infor))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"10\"}";//删除失败
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
    //根据id查可以管理的实验
    public string Exper_LoginByID(string ID, string PW)
    {
        ExpermentLogin expermentLogin = new ExpermentLogin();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(expermentLogin.FindDataByID(ID));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //根据实验名查可以管理的人员名
    public string Exper_LoginByName(string ID, string PW, string infor)
    {
        ExpermentLogin expermentLogin = new ExpermentLogin();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                return dsToJson(expermentLogin.FindDataByExp(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //对一个实验对应的管理人员做操作
    public string Exper_LoginInsert_Update(string ID, string PW, string infor, string experment_name)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        ExpermentLogin expermentLogin = new ExpermentLogin();
        Experment_Login experment_Login = new Experment_Login();
        ExpermentInfo expermentInfo = new ExpermentInfo();
        if (PW.Equals(login_rank1.PW))
        {

            if (login_rank1.rank_experment == "管理权限" || (login_rank1.rank_experment == "一般权限" && expermentLogin.Rank_add(experment_name, ID)))
            {
                DataSet ds = expermentInfo.FindData(experment_name);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"11\"}";//信息不存在
                }
                if (expermentLogin.DeleteData(experment_name))
                {
                    if (infor != "")
                    {

                        JArray ja2 = (JArray)JsonConvert.DeserializeObject(infor);
                        for (int i = 0; i < ja2.Count; i++)
                        {
                            experment_Login.experment_name = experment_name;
                            experment_Login.ID = ja2[i]["ID"].ToString();
                            experment_Login.name = ja2[i]["name"].ToString();
                            experment_Login.isAdd = ja2[i]["isAdd"].ToString();
                            expermentLogin.Add_UpdateData(experment_Login);
                        }
                    }

                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//更新失败
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

    //根据id查是否有添加人修改实验的权限
    public bool Exper_Check(string ID, string PW, string experment_name)
    {
        ExpermentLogin expermentLogin = new ExpermentLogin();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_experment == "没有权限")
            {
                return false;
            }
            else
            {
                return expermentLogin.Rank_add(experment_name, ID);
            }
        }
        else
        {
            return false;
        }

    }
    //两个dataset中表去重
    private DataSet DatasetToDataset(DataSet ds1, DataSet ds2)
    {
        if (ds1.Tables[0].Rows.Count == 0)
        {
            ds1 = ds2;
        }
        else
        {
            for (int i = 0; i < ds2.Tables[0].Rows.Count; i++)
            {
                for (int k = 0; k < ds1.Tables[0].Rows.Count; k++)
                {
                    if (ds1.Tables[0].Rows[k]["drug_name"].ToString().Trim() == ds2.Tables[0].Rows[i]["drug_name"].ToString().Trim())
                    {
                        ds1.Tables[0].Rows[k]["num"] = (double)ds1.Tables[0].Rows[k]["num"] + (double)ds2.Tables[0].Rows[i]["num"];
                        break;
                    }
                    if (k == ds1.Tables[0].Rows.Count - 1)
                    {
                        DataRow dr = ds1.Tables[0].NewRow();
                        dr["drug_name"] = ds2.Tables[0].Rows[i]["drug_name"];
                        dr["num"] = (double)ds2.Tables[0].Rows[i]["num"];
                        ds1.Tables[0].Rows.Add(dr);

                        break;
                    }
                }
            }

        }

        return ds1;
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