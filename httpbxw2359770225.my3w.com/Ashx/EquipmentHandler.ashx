<%@ WebHandler Language="C#" Class="Equipment_Handler" %>
using System;
using System.Web;
using Equipment.BLL;
using System.Data;
using Login_Rank_Information.BLL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
public class Equipment_Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";
        context.Response.AddHeader("Access-Control-Allow-Origin", "*");
        context.Response.AddHeader("Access-Control-Allow-Methods", "POST");
        context.Response.AddHeader("Access-Control-Max-Age", "1000");
        string infor = "[" + context.Request["json"] + "]";
        JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
        string Type = ja[0]["type"].ToString();
        



    //获得仪器信息
    if (Type.Equals("GetEquip"))
    {
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();
        string equip_name = ja[0]["equip_name"].ToString();
        context.Response.Write(GetEquip(ID, PW, equip_name));
    }
    else if (Type.Equals("GetEquipDetail"))
    {
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();
        string equip_name = ja[0]["equip_name"].ToString();
        context.Response.Write(GetEquipDetail(ID, PW, equip_name));
    }
    else if (Type.Equals("Equip_Insert_Update"))
    {
       string ID = ja[0]["id"].ToString();
       string PW = ja[0]["pw"].ToString();
       string equip_name = ja[0]["equip_old"].ToString();
        context.Response.Write(Equip_Insert_Update(ID, PW,infor,equip_name));
    }
        
    else if (Type.Equals("Equip_Delete"))
    {
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();
        string equip_name = ja[0]["equip_name"].ToString();
        context.Response.Write(Equip_Delete(ID, PW, equip_name));
    }
    else if (Type.Equals("GetEquipLoc"))
    {
        string fixed_assets_NO = ja[0]["fixed_assets_NO"].ToString();
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();

        context.Response.Write(GetEquipLoc(ID, PW, fixed_assets_NO));
    }
    else if (Type.Equals("GetEquipLocDetail"))
    {
        string equip_name = ja[0]["equip_name"].ToString();
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();

        context.Response.Write(GetEquipLocDetail(ID, PW, equip_name));
    }
    else if (Type.Equals("EquipLoc_Update"))
    {
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();
        string old_fixed_assets_NO = ja[0]["old_fixed_assets_NO"].ToString();
        context.Response.Write(EquipLoc_Update(ID, PW, infor, old_fixed_assets_NO));
    }
    else if (Type.Equals("EquipLoc_Insert"))
    {
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();
            
        context.Response.Write(EquipLoc_Insert(ID, PW, infor));
    }
    else if (Type.Equals("EquipLoc_Delete"))
    {
        string ID = ja[0]["id"].ToString();
        string PW = ja[0]["pw"].ToString();
        string fixed_assets_NO = ja[0]["fixed_assets_NO"].ToString();
        context.Response.Write(EquipLoc_Delete(ID, PW, fixed_assets_NO));
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

    
   //获得仪器信息
    public string GetEquip(string ID, string PW, string infor)
    {
        
        EquipmentInfo equipmentInfo = new EquipmentInfo();
       
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            
            if (login_rank1.rank_equipment == "没有权限")
            {
                return dsToJson(equipmentInfo.LoadData(infor));
            }
            else
            {
               
                return dsToJson(equipmentInfo.LoadData(infor));
            }
        }
        else
        {
            return dsToJson(equipmentInfo.LoadData(infor));
        }

    }
    //获得仪器信息
    public string GetEquipDetail(string ID, string PW, string infor)
    {

        EquipmentInfo equipmentInfo = new EquipmentInfo();

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {

            if (login_rank1.rank_equipment == "没有权限")
            {

                return "{\"error\":\"02\"}";//无权限
            }
            else
            {
                DataSet ds = equipmentInfo.LoadDataDetail(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"10\"}";//信息不存在
                }
                return dsToJson(ds);
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    
    //仪器增改 
    public string Equip_Insert_Update(string ID, string PW, string infor, string equip_name )
    {

        EquipmentInfo equipmentInfo = new EquipmentInfo();
        Equipment_Information equipment_Inf = new Equipment_Information();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);

        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_equipment == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                equipment_Inf.equip_name = ja[0]["equip_name"].ToString();
                equipment_Inf.model = ja[0]["model"].ToString();
                equipment_Inf.factory = ja[0]["factory"].ToString();
                equipment_Inf.detail = ja[0]["detail"].ToString();
                equipment_Inf.price = ja[0]["price"].ToString();

                
                if (equipmentInfo.Add_UpdateData(equipment_Inf, equip_name))
                {

                    return "{\"error\":\"0\"}";//成功
                   

                }
                else
                {
                    return "{\"error\":\"03\"}";//"增加仪器名重复或者修改时仪器名出现问题"
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
    //仪器删除
    public string Equip_Delete(string ID, string PW, string infor)
    {

        EquipmentInfo equipmentInfo = new EquipmentInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_equipment == "管理权限" )
            {
                DataSet ds = equipmentInfo.LoadDataDetail(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"10\"}";//删除信息不存在
                }
                if (equipmentInfo.DeleteData(infor))
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
    //获得仪器位置信息
    public string GetEquipLoc(string ID, string PW, string infor)
    {
        EquipmentLoc equipmentLoc = new EquipmentLoc();
       

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);

        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_equipment == "管理权限" )
            {
                return dsToJson(equipmentLoc.LoadData(infor));
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
    //获得仪器位置信息
    public string GetEquipLocDetail(string ID, string PW, string infor)
    {
        EquipmentLoc equipmentLoc = new EquipmentLoc();


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);

        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_equipment == "没有权限")
            {

                return "{\"error\":\"02\"}";//无权限
               
            }
            else
            {

                DataSet ds = equipmentLoc.LoadDataDetail(infor);
               
                return dsToJson(ds);
                
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //具体仪器增改 
    public string EquipLoc_Insert(string ID, string PW, string infor)
    {

        EquipmentLoc equipmentLoc = new EquipmentLoc();
        Equipment_Loc equipment_Loc = new Equipment_Loc();
      
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);

        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_equipment == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                equipment_Loc.equip_name = ja[0]["equip_name"].ToString();
                equipment_Loc.fixed_assets_NO = ja[0]["fixed_assets_NO"].ToString();
                equipment_Loc.factory_NO = ja[0]["factory_NO"].ToString();
                equipment_Loc.time_buying = ja[0]["time_buying"].ToString();
                equipment_Loc.people = ja[0]["people"].ToString();
                equipment_Loc.position = ja[0]["position"].ToString();
                equipment_Loc.state = ja[0]["state"].ToString();
                equipment_Loc.state_explane = ja[0]["state_explane"].ToString();

               

                if (equipmentLoc.Add_Data(equipment_Loc))
                {

                    return "{\"error\":\"0\"}";//成功


                }
                else
                {
                    return "{\"error\":\"03\"}";//"失败，固定资产号存在"
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
    //具体仪器增改 
    public string EquipLoc_Update(string ID, string PW, string infor, string no)
    {

        EquipmentLoc equipmentLoc = new EquipmentLoc();
        Equipment_Loc equipment_Loc = new Equipment_Loc();

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);

        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_equipment == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                equipment_Loc.equip_name = ja[0]["equip_name"].ToString();
                equipment_Loc.fixed_assets_NO = ja[0]["fixed_assets_NO"].ToString();
                equipment_Loc.factory_NO = ja[0]["factory_NO"].ToString();
                equipment_Loc.time_buying = ja[0]["time_buying"].ToString();
                equipment_Loc.people = ja[0]["people"].ToString();
                equipment_Loc.position = ja[0]["position"].ToString();
                equipment_Loc.state = ja[0]["state"].ToString();
                equipment_Loc.state_explane = ja[0]["state_explane"].ToString();



                if (equipmentLoc.Update_Data(equipment_Loc, no))
                {

                    return "{\"error\":\"0\"}";//成功


                }
                else
                {
                    return "{\"error\":\"04\"}";//"失败，原固定资产号不存在或者修改后的固定资产号存在"
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
    //具体仪器删除
    public string EquipLoc_Delete(string ID, string PW, string infor)
    {

        EquipmentLoc equipmentLoc = new EquipmentLoc();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_equipment == "管理权限")
            {
                DataSet ds = equipmentLoc.LoadDataByNo(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"10\"}";//删除信息不存在
                }
                if (equipmentLoc.DeleteData(infor))
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
                return "{\"error\":\"02\"}";//无权限return "无权限";
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