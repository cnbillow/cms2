﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogManage.aspx.cs" Inherits="ZoomLaCMS.Manage.Plus.LogManage" MasterPageFile="~/Manage/I/Index.master" ClientIDMode="Static" EnableViewStateMac="false" %>
<asp:Content runat="server" ContentPlaceHolderID="head">
    <title>日志管理</title>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <%=Call.SetBread(new Bread[] {
		new Bread("/{manage}/Main.aspx","工作台"),
        new Bread("LogManage.aspx","日志管理"),	
        new Bread() {url="", text="管理员登录日志",addon="" }}
		)
    %>
    <div class="list_choice">
        <ZL:ExGridView ID="EGV" class="table table-striped table-bordered table-hover"  runat="server" AutoGenerateColumns="False"
            AllowPaging="True" PageSize="15" OnPageIndexChanging="EGV_PageIndexChanging" EmptyDataText="无相关数据">
            <Columns>
               <asp:TemplateField HeaderText="">
                   <ItemTemplate><input type="checkbox" name="idchk" value="<%#Eval("ID") %>" /></ItemTemplate>
               </asp:TemplateField>
                <asp:BoundField HeaderText="用户名" DataField="UName" />
                <asp:BoundField HeaderText="IP" DataField="IP" />
                <asp:BoundField HeaderText="时间" DataField="CDate" />
                <asp:BoundField HeaderText="操作" DataField="Action" />
                <asp:BoundField HeaderText="详情" DataField="Message" />
            </Columns>
        </ZL:ExGridView>
    </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
</asp:Content>
