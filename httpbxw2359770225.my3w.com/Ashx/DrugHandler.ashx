<%@ WebHandler Language="C#" Class="DrugHandler" %>

using System;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using Drug.BLL;
using Login_Rank_Information.BLL;
public class DrugHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";
        context.Response.AddHeader("Access-Control-Allow-Origin", "*");
        context.Response.AddHeader("Access-Control-Allow-Methods", "POST");
        context.Response.AddHeader("Access-Control-Max-Age", "1000");
        string infor = "["+context.Request["json"]+"]";
        
     
        
         JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
         string Type = ja[0]["type"].ToString();
         string ID = ja[0]["id"].ToString();
         string PW = ja[0]["pw"].ToString();

         
         if (Type.Equals("GetDrug"))
         {//模糊查找获得药品基本信息
 
             string drug_name = ja[0]["drug"].ToString();
             context.Response.Write(GetDrug(ID, PW, drug_name));
         }
         else if (Type.Equals("GetDrugDetail"))
         {//精确查找获得药品详细信息
             string drug_name = ja[0]["drug"].ToString(); 
             context.Response.Write(GetDrugDetail(ID, PW, drug_name));
         }
         else if (Type.Equals("Drug_Insert_Update"))
         {//药品增改
             string drug_name = ja[0]["drug_old"].ToString(); 
           
             context.Response.Write(Drug_Insert_Update(ID, PW, infor, drug_name));
         }
         else if (Type.Equals("Drug_Delete"))
         {//药品删除
             string drug_name = ja[0]["drug"].ToString(); 
             context.Response.Write(Drug_Delete(ID, PW,drug_name));
         }
            
         else if (Type.Equals("GetDrugLoc"))
         {//获得药品的所有位置信息
             string drug_name = ja[0]["drug"].ToString(); 
             context.Response.Write(GetDrugLoc(ID, PW, drug_name));
         }
         else if (Type.Equals("GetDrugLocDetail"))
         {//获得药品的详细位置信息
             string drug_name_locId = ja[0]["loc"].ToString(); 
             context.Response.Write(GetDrugLocDetail(ID, PW, drug_name_locId));
         }
        
         else if (Type.Equals("Drug_Insert_UpdateLoc"))
         {//位置信息增改
             context.Response.Write(Drug_Insert_UpdateLoc(ID, PW, infor));
         }
         else if (Type.Equals("Drug_DeleteLoc"))
         {//位置信息删除
             string drug_name_locId = ja[0]["loc"].ToString(); 
             context.Response.Write(Drug_DeleteLoc(ID, PW, drug_name_locId));
         }
         else if (Type.Equals("GetDrugInOutByName"))
         {//出入库信息
             string drug_name = ja[0]["drug"].ToString();
             string time1 = ja[0]["from"].ToString();
             string time2 = ja[0]["to"].ToString(); 

             context.Response.Write(GetDrugInOutByName(ID, PW, drug_name, time1, time2));
         }
         else if (Type.Equals("GetDrugMix"))
         {//模糊查找试剂基本信息
             string drug_mix = ja[0]["mix"].ToString();
             context.Response.Write(GetDrugMix(ID, PW, drug_mix));
         }
         else if (Type.Equals("GetDrugMixByName"))
         {//试剂详细信息
             string drug_mix = ja[0]["mix"].ToString();
             context.Response.Write(GetDrugMixByName(ID, PW, drug_mix));
         }
         else if (Type.Equals("GetDrugMix_Struct"))
         {//试剂配方表
             string drug_mix = ja[0]["mix"].ToString();
             context.Response.Write(GetDrugMix_Struct(ID, PW, drug_mix));
         }
         else if (Type.Equals("DrugMix_Insert_Update"))
         {//试剂增改
             string drug_mix = ja[0]["mix_old"].ToString();      
             context.Response.Write(DrugMix_Insert_Update(ID, PW, infor ,drug_mix));
         }
         else if (Type.Equals("DrugMixDrug_Insert_Update"))
         {//试剂配方增改
             string drug_mix = ja[0]["mix"].ToString();
             string[] sArray = infor.Split('[');
             string[] infor1 =  sArray[2].ToString().Split(']'); 
             string[] infor2 = sArray[3].ToString().Split(']');
             
             if (infor1[0] != "")
                 infor1[0] = "[" + infor1[0] + "]";
             if (infor2[0] != "")
                infor2[0] = "[" + infor2[0] + "]";
             //context.Response.Write(drug_mix);
             context.Response.Write(DrugMixDrug_Insert_Update(ID, PW, infor1[0], infor2[0], drug_mix));
         }
         else if (Type.Equals("DrugMix_Delete"))
         {//试剂删除
             string drug_mix = ja[0]["mix"].ToString();
             context.Response.Write(DrugMix_Delete(ID, PW, drug_mix));
         }
         else
         {
             //context.Response.Write(Type);
             context.Response.Write("不存在该方法");
         }
          
    }
 
    
    public bool IsReusable {
        get {
            return false;
        }
    }
     //通过模糊查找获得药品大致信息
    public string GetDrug(string ID, string PW, string infor)
    {
       
       
        DrugInfo drugInfo = new DrugInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "没有权限")
            {
                return DataSetToJson(drugInfo.LoadData_NoRank(infor));
            }
            else
            {
                return DataSetToJson(drugInfo.LoadData(infor));
            }
        }
        else
        {
            return DataSetToJson(drugInfo.LoadData_NoRank(infor));
        }
        
    }
    //获得药品详细信息
    public string GetDrugDetail(string ID, string PW, string infor)
    {
        // return infor;
        DrugInfo drugInfo = new DrugInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
           
            if (login_rank1.rank_drug == "没有权限")
            {
                DataSet ds = drugInfo.FindData_NoRank(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"07\"}";
                }
                else
                {
                    return DataSetToJson(ds);
                }
               
            }
            else
            {
                DataSet ds = drugInfo.FindData(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"07\"}";
                }
                else
                {
                    return DataSetToJson(ds);
                }
                
               
            }
        }
        else
        {
            DataSet ds = drugInfo.FindData_NoRank(infor);
            if (ds.Tables[0].Rows.Count == 0)
            {
                return "{\"error\":\"07\"}";
            }
            else
            {
                return DataSetToJson(ds);
            }
        }

    }
    //药品增改 
    public string Drug_Insert_Update(string ID, string PW, string infor, string drug_name)
    {
        DrugInfo drugInfo = new DrugInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        Drug_Information drug_Information = new Drug_Information();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                drug_Information.drug_name = ja[0]["drug"].ToString();
                drug_Information.drug_another_name = ja[0]["drug_another_name"].ToString();
                drug_Information.drug_Englishname = ja[0]["drug_Englishname"].ToString();
                drug_Information.fen_zi_shi = ja[0]["fen_zi_shi"].ToString();
                drug_Information.fen_zi_liang = ja[0]["fen_zi_liang"].ToString();
                drug_Information.CAS = ja[0]["CAS"].ToString();
                drug_Information.details = ja[0]["details"].ToString();
                drug_Information.dangerous = ja[0]["dangerous"].ToString();
                drug_Information.standard = ja[0]["standard"].ToString();
                drug_Information.people = ja[0]["people"].ToString();
                drug_Information.edit_time = DateTime.Now;

                if (drug_name=="-1")
                {
                    if (drugInfo.IsDrug_name(drug_Information.drug_name))
                    {

                        return "{\"error\":\"03\"}";// "失败，该药品名已存在，此操作会覆盖之前的记录，请在原药品位置修改";

                    }
                    else
                    {
                        if (drugInfo.Add_UpdateData(drug_Information, drug_Information.drug_name))
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
                    if (drugInfo.IsDrug_name(drug_name))//旧药品名存在
                    {
                        if (drugInfo.IsDrug_name(drug_Information.drug_name) && drug_name != drug_Information.drug_name)
                            {

                                return "{\"error\":\"03\"}";// "失败，该药品名已存在，此操作会覆盖之前的记录，请在原药品位置修改";

                            }
                            else
                            {
                                if (drugInfo.Add_UpdateData(drug_Information, drug_name))
                                {

                                    DrugLoc drugLoc = new DrugLoc();
                                    drugLoc.UpdateStandard(drug_name, drug_Information.standard);
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
                        return "{\"error\":\"08\"}";// "失败，原药品名不存在 无法进行更新";
                        
                        
                    }
                   


                    
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
    //药品删除
    public string Drug_Delete(string ID, string PW, string infor)
    {

        DrugInfo drugInfo = new DrugInfo();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        Drug_Information drug_Information = new Drug_Information();
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "管理权限")
            {
                DataSet ds = drugInfo.FindData(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"10\"}";//删除信息不存在
                }
                if (drugInfo.DeleteData(infor))
                {

                    return "{\"error\":\"0\"}";//登录
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
            
        }
        {
            return "{\"error\":\"01\"}";//未登录
        }

    }
    //通过精确的id获得药品所有位置信息
    public string GetDrugLoc(string ID, string PW, string infor)
    {


        DrugLoc drugLoc = new DrugLoc();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);

        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "没有权限")
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
            else
            {
                return DataSetToJson(drugLoc.FindData(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";// "未登录”
        }

    }
    //通过精确的id获得药品某个位置信息
     public string GetDrugLocDetail(string ID, string PW, string infor)
     {


         DrugLoc drugLoc = new DrugLoc();
         LoginRankInformation login_getinformation = new LoginRankInformation();
         login_rank login_rank1 = login_getinformation.LoadData(ID);
         if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
         {
             if (login_rank1.rank_drug == "没有权限")
             {
                 return "{\"error\":\"02\"}";// "失败，无权限”
             }
             else
             {
                 DataSet ds = drugLoc.FindDataDetail(infor);
                 if (ds.Tables[0].Rows.Count == 0)
                 {
                     return "{\"error\":\"07\"}";
                 }
                 else
                 {
                     return DataSetToJson(ds);
                 }
                 
             }
         }
         else
         {
             return "{\"error\":\"01\"}";//失败 未登录
         }

     }
    
    
    //药品位置修改 
    public string Drug_Insert_UpdateLoc(string ID, string PW, string infor)
    {
        double change = 0;
        string position;
        DrugInfo drugInfo = new DrugInfo();
        DrugLoc drugLoc = new DrugLoc();
        Drug_Loc drug_Loc = new Drug_Loc();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                drug_Loc.id = (int)ja[0]["loc"];
                drug_Loc.drug_name = ja[0]["drug"].ToString();
                drug_Loc.position = ja[0]["position"].ToString();
                drug_Loc.counting = (int)ja[0]["counting"];
                drug_Loc.remain = (double)ja[0]["remain"];
                drug_Loc.each = (double)ja[0]["each"];
                drug_Loc.standard = drugInfo.GetStandard(drug_Loc.drug_name);
                drug_Loc.people = ja[0]["people"].ToString();
                drug_Loc.edit_time = DateTime.Now;
                
                change = drug_Loc.counting * 1.0;
                change = change * (double)drug_Loc.each + drug_Loc.remain;

                Drug_In_Out drug_In_Out = new Drug_In_Out();
                if (drug_Loc.id != -1)
                {
                    
                    position = drugLoc.Positon(drug_Loc.id);
                    if (position != drug_Loc.position.ToString().Trim())
                    {

                        drug_In_Out.drug_name = drug_Loc.drug_name;
                        drug_In_Out.change = drugLoc.Change(drug_Loc.id);
                        drug_In_Out.people = drug_Loc.people;
                        drug_In_Out.standard = drug_Loc.standard;
                        drug_In_Out.type = "取";
                        drug_In_Out.position = position;

                        DrugInOut drugInOut = new DrugInOut();

                        drugInOut.InsertData(drug_In_Out);

                        drug_In_Out.change = change;
                        drug_In_Out.type = "存";
                        drug_In_Out.position = drug_Loc.position;
                        drugInOut.InsertData(drug_In_Out);

                        change = change - drugLoc.Change(drug_Loc.id);

                        if (change != 0)
                        {

                            string type;
                            if (change < 0)
                            {
                                type = "取";
                                change = -1 * change;
                            }

                            else
                                type = "存";
                            if (drugInfo.Change(drug_In_Out.drug_name, type, change))
                            {
                                return "{\"error\":\"0\"}"; // "成功"
                            }
                            return "{\"error\":\"04\"}"; // "失败，修改药品信息失败";
                        }
                        else
                        {
                            return "{\"error\":\"0\"}"; // "成功"
                        }

                    }
                    else
                    {
                        change = change - drugLoc.Change(drug_Loc.id);
                    }

                }
                
                    
                
                if (drugLoc.Add_UpdateData(drug_Loc))
                {
                   
                    if (change != 0)
                    {
                       
                        string type;
                        if (change < 0)
                        {  
                            type = "取";
                            change = -1 * change;
                        }
                          
                        else
                            type = "存";
                        drug_In_Out.drug_name = drug_Loc.drug_name;
                        drug_In_Out.change = change;
                        drug_In_Out.people = drug_Loc.people;
                        drug_In_Out.standard = drug_Loc.standard;
                        drug_In_Out.type = type;
                        drug_In_Out.position = drug_Loc.position;
                        DrugInOut drugInOut = new DrugInOut();
                        if (drugInOut.InsertData(drug_In_Out))
                        {

                           
                            if (drugInfo.Change(drug_In_Out.drug_name, type, change))
                            {
                                return "{\"error\":\"0\"}"; // "成功"
                            }
                            return "{\"error\":\"04\"}"; // "失败，修改药品信息失败";
                        }
                        else
                        {
                            return "{\"error\":\"05\"}"; // "失败，出入库表插入失败";
                        }
                    }
                    return "{\"error\":\"0\"}"; // "成功"
                }
                else
                {
                    return "{\"error\":\"09\"}"; //"失败，未知原因操作失败，请重试或联系管理员"
                }
               

            }
            else
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    /*
    //药品位置批量修改 
    public string Drug_Insert_UpdateLocAll(string ID, string PW, string infor)
    {
        DrugLoc drugLoc = new DrugLoc();
        Drug_Loc drug_Loc = new Drug_Loc();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        double change;
        double change_all=0;
        Drug_In_Out drug_In_Out = new Drug_In_Out();
        string type;
        if (PW.Equals(login_rank1.PW))
        {
            if (login_rank1.rank_drug == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);

                for (int i = 0; i < ja.Count; i++)
                {
                    drug_Loc.id = (int)ja[i]["id"];
                    drug_Loc.drug_name = ja[i]["drug_name"].ToString();
                    drug_Loc.position = ja[i]["position"].ToString();
                    drug_Loc.counting = (int)ja[i]["counting"];
                    drug_Loc.remain = (double)ja[i]["remain"];
                    drug_Loc.each = (double)ja[i]["each"];
                    drug_Loc.standard = ja[i]["standard"].ToString();
                    drug_Loc.people = ja[i]["people"].ToString();
                    drug_Loc.standard = ja[i]["standard"].ToString();
                    drug_Loc.people = ja[i]["people"].ToString();
                    change = (double)ja[i]["change"];
                    drug_Loc.edit_time = DateTime.Now;
                    change_all = change_all + change;
                    if (drugLoc.Add_UpdateData(drug_Loc))
                    {
                        if (change != 0)
                        {
                           
                            if (change < 0)
                            {
                                type = "取";
                                change = -1 * change;
                            }

                            else
                                type = "存";


                            drug_In_Out.drug_name = drug_Loc.drug_name;
                            drug_In_Out.change = change;
                            drug_In_Out.people = drug_Loc.people;
                            drug_In_Out.standard = drug_Loc.standard;
                            drug_In_Out.type = type;
                            drug_In_Out.position = drug_Loc.position;
                            DrugInOut drugInOut = new DrugInOut();
                            if (drugInOut.InsertData(drug_In_Out))
                            {

                             
                            }
                            else
                            {
                                return "失败，修改成功但出入库表插入失败";
                            }
                        }
                        
                    }

                    else
                    {
                        return "失败";
                    }


                
                }
                if (change_all < 0)
                {
                    type = "取";
                    change = -1 * change_all;
                }

                else
                    type = "存";
                DrugInfo drugInfo = new DrugInfo();
                if (drugInfo.Change(drug_In_Out.drug_name, type, change_all))
                {
                    return "成功";
                }
                return "失败，修改成功并且出入库表插入成功但信息修改失败";


            }
            else
            {
                return "无权限";
            }
        }
        else
        {
            return "未登录";
        }

    }
    */
    


    //药品位置信息删除
    public string Drug_DeleteLoc(string ID, string PW, string infor)
    {
        DrugLoc drugLoc = new DrugLoc();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        Drug_Information drug_Information = new Drug_Information();
        double change = 0;
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "管理权限" )
            {

                DataSet ds = drugLoc.FindDataDetail(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"10\"}";//删除信息不存在
                }
                
                change = drugLoc.Change(Convert.ToInt32(infor))*(-1);
                
                if (change != 0)
                {
                    
                    Drug_Loc drug_Loc = new Drug_Loc();
                    

                        drug_Loc.drug_name = ds.Tables[0].Rows[0]["drug_name"].ToString().Trim();
                        drug_Loc.people = ds.Tables[0].Rows[0]["people"].ToString().Trim();
                        drug_Loc.standard = ds.Tables[0].Rows[0]["standard"].ToString().Trim();
                        drug_Loc.position = ds.Tables[0].Rows[0]["position"].ToString().Trim();

                    

                    

                    Drug_In_Out drug_In_Out = new Drug_In_Out();
                    string type;
                    if (change < 0)
                    {
                        type = "取";
                        change = -1 * change;
                    }

                    else
                        type = "存";
                    drug_In_Out.drug_name = drug_Loc.drug_name;
                    drug_In_Out.change = change;
                    drug_In_Out.people = drug_Loc.people;
                    drug_In_Out.standard = drug_Loc.standard;
                    drug_In_Out.type = type;
                    drug_In_Out.position = drug_Loc.position;
                    DrugInOut drugInOut = new DrugInOut();
                            if (drugInOut.InsertData(drug_In_Out))
                            {

                                DrugInfo drugInfo = new DrugInfo();
                                if (drugInfo.Change(drug_In_Out.drug_name, type, change))
                                {
                                    if (drugLoc.DeleteData(infor))
                                    {
                                        return "{\"error\":\"0\"}";// "成功”
                                    }
                                    else
                                    {
                                        return "{\"error\":\"09\"}";// "失败，未知原因操作失败，请重试或联系管理员"
                                    }
                               
                                }
                                return "{\"error\":\"09\"}";// "失败，未知原因操作失败，请重试或联系管理员"
                             }
                                else
                                {
                                    return "{\"error\":\"09\"}";// "失败，未知原因操作失败，请重试或联系管理员"
                                }
                     }
                    else
                    {
                        if (drugLoc.DeleteData(infor))
                        {
                            return "{\"error\":\"0\"}";// "成功”
                        }
                        else
                        {
                            return "{\"error\":\"09\"}";// "失败，未知原因操作失败，请重试或联系管理员"
                        }
                    }

                   

            }
            else
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //通过药品名查出入库记录
    public string GetDrugInOutByName(string ID, string PW, string infor,string time1, string time2)
    {
        // return infor;
        DrugInOut drugInOut = new DrugInOut();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "没有权限")
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
            else
            {
                return DataSetToJson(drugInOut.FindDataByName(infor, time1, time2));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }

    //获得试剂信息
    public string GetDrugMix(string ID, string PW, string infor)
    {

        DrugMix drugMix = new DrugMix();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "没有权限")
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
            else
            {
                return DataSetToJson(drugMix.LoadData(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //通过准确的试剂名称获得试剂信息
    public string GetDrugMixByName(string ID, string PW, string infor)
    {

        DrugMix drugMix = new DrugMix();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "没有权限")
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
            else
            {
                DataSet ds = drugMix.LoadDataByName(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"07\"}";
                }
                else
                {
                    return DataSetToJson(ds);
                }
                
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //获得试剂配方
    public string GetDrugMix_Struct(string ID, string PW, string infor)
    {
        DrugMixDrug drugMixDrug = new DrugMixDrug();

        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "没有权限")
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
            else
            {
                return DataSetToJson(drugMixDrug.FindData(infor));
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //试剂信息增改 drug_mix为修改前的试剂名（用来定位记录）

    public string DrugMix_Insert_Update(string ID, string PW, string infor , string drug_mix)
    {


        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        //试剂基本情况
        Drug_Mix drug_Mix = new Drug_Mix();
        DrugMix drugMix = new DrugMix();


        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "管理权限")
            {
               
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
                drug_Mix.drug_mix = ja[0]["mix"].ToString();
                drug_Mix.attention = ja[0]["attention"].ToString();
                drug_Mix.standard = ja[0]["standard"].ToString();


                if (drug_Mix.drug_mix != drug_mix && drugMix.IsDrug_Mix(drug_Mix.drug_mix))
                {

                    return "失败，该试剂名已存在，此操作会覆盖之前的记录，请在原试剂位置修改";

                }
                else
                {
                    if (drugMix.Add_UpdateData(drug_Mix, drug_mix))
                    {


                        return "{\"error\":\"0\"}"; // "成功"
                    }
                    else
                    {
                        return "{\"error\":\"09\"}";// "失败，未知原因操作失败，请重试或联系管理员"
                    }
                }
               
            }
            else
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //配方增改 drug_mix为修改前的试剂名（用来定位记录）
    public string DrugMixDrug_Insert_Update(string ID, string PW, string infor2, string infor3, string drug_mix)
    {
       
        
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        //试剂基本情况
        Drug_Mix drug_Mix = new Drug_Mix();
        DrugMix drugMix = new DrugMix();
        //试剂配方
        DrugMixDrug drugMixDrug = new DrugMixDrug();
        Drug_MixDrug drug_MixDrug = new Drug_MixDrug();

        DataSet drug_mixdrugAll = new DataSet();
        DataTable dt = drug_mixdrugAll.Tables.Add("Table");
        dt.Columns.Add("drug_mix", System.Type.GetType("System.String"));
        dt.Columns.Add("drug_name", System.Type.GetType("System.String"));
        dt.Columns.Add("num", System.Type.GetType("System.Double"));
        dt.Columns.Add("standard", System.Type.GetType("System.String"));


        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            
            if (login_rank1.rank_drug == "管理权限")
            {

                if (drug_mix!=""&&drugMixDrug.DeleteData(drug_mix))
                    {
                        
                        if(infor2=="")
                        {

                        }
                        else
                        {
                            
                            JArray ja2 = (JArray)JsonConvert.DeserializeObject(infor2);
                            for (int i = 0; i < ja2.Count; i++)
                            {
                                
                                drug_MixDrug.drug_mix = drug_mix;
                                drug_MixDrug.drug_name = ja2[i]["drug"].ToString();
                                drug_MixDrug.num = (double)ja2[i]["num"];
                                drug_MixDrug.standard = ja2[i]["standard"].ToString();
                                
                                
                                if(infor3=="")
                                {
                                   drugMixDrug.Add_UpdateData(drug_MixDrug);
                                }
                                else
                                {
                                    DataRow dr = dt.NewRow();
                                    dr["drug_mix"] = drug_MixDrug.drug_mix;
                                    dr["drug_name"] = drug_MixDrug.drug_name;
                                    dr["num"] = drug_MixDrug.num;
                                    dr["standard"] = drug_MixDrug.standard;
                                    dt.Rows.Add(dr);
                                }
                                
                            }
                             
                            
                        }
                    
                        if(infor3=="")
                        {

                        }
                        else
                        {
                           
                            JArray ja3 = (JArray)JsonConvert.DeserializeObject(infor3);

                            double num_drug_mix;
                            string drug_mixname;
                            for (int i = 0; i < ja3.Count; i++)
                            {
                                drug_mixname = ja3[i]["mix"].ToString();
                                num_drug_mix = (double)ja3[i]["num"];
                                
                                DataSet ds1 = new DataSet();
                                ds1 = drugMixDrug.FindData(drug_mixname);
                               
                                for (int k = 0; k < ds1.Tables[0].Rows.Count;k++ )
                                {
                                    ds1.Tables[0].Rows[k]["num"] = (double)ds1.Tables[0].Rows[k]["num"] * num_drug_mix;
                                }
                                
                                    drug_mixdrugAll = DatasetToDataset(drug_mixdrugAll, ds1);
                               
                            }

                            
                            for(int i = 0;i<drug_mixdrugAll.Tables[0].Rows.Count;i++)
                            {
                                drug_MixDrug.drug_mix = drug_mix;
                                drug_MixDrug.drug_name = drug_mixdrugAll.Tables[0].Rows[i]["drug_name"].ToString();
                                drug_MixDrug.num = (double)drug_mixdrugAll.Tables[0].Rows[i]["num"];
                                drug_MixDrug.standard = drug_mixdrugAll.Tables[0].Rows[i]["standard"].ToString();
                                drugMixDrug.Add_UpdateData(drug_MixDrug);
                            }
                             
                        }

                        return "{\"error\":\"0\"}"; // "成功"
                   
                    }
                    else
                    {
                        return "{\"error\":\"09\"}";// "失败，未知原因操作失败，请重试或联系管理员"
                    }
                  

            }
            else
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }

    }
    //试剂删除
    public string DrugMix_Delete(string ID, string PW, string infor)
    {

        DrugMix drugMix = new DrugMix();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_drug == "管理权限")
            {
                DataSet ds = drugMix.LoadDataByName(infor);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    return "{\"error\":\"10\"}";//删除信息不存在
                }
                if (drugMix.DeleteData(infor))
                {
                    return "{\"error\":\"0\"}"; // "成功"
                }
                else
                {
                    return "{\"error\":\"09\"}";// "失败，未知原因操作失败，请重试或联系管理员"
                }
            }
            else
            {
                return "{\"error\":\"02\"}";// "失败，无权限”
            }
        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
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
                        dr["drug_mix"] = ds2.Tables[0].Rows[i]["drug_mix"];
                        dr["drug_name"] = ds2.Tables[0].Rows[i]["drug_name"];
                        dr["num"] = (double)ds2.Tables[0].Rows[i]["num"];
                        dr["standard"] = ds2.Tables[0].Rows[i]["standard"];
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
        System.Text.StringBuilder str = new System.Text.StringBuilder("");

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            if (i > 0)
                str.Append("{\"error\":\"0\",\"data\":[{");
            
            for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
            {
                str.Append(string.Format("\"", ds.Tables[0].Columns[j].ColumnName, "\":\"", ds.Tables[0].Rows[i][j].ToString().Trim()));
                str.Append("\"");
                if (j < ds.Tables[0].Columns.Count - 1)
                {
                    str.Append(","); 
                }
                if (i < ds.Tables[0].Rows.Count - 1)
                {
                    str.Append(","); 
                }
            }
            
            str.Append("}");
        }

        str.Append("}]}");

        
        return str.ToString();
    }
    string DataSetToJson(DataSet ds)
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