﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddGroup.aspx.cs" Inherits="ZoomLaCMS.Plat.Admin.AddGroup"  MasterPageFile="~/Plat/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>部门管理</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<div class="container platcontainer">
<div class="child_head"><span class="child_head_span1"></span> <span class="child_head_span2">部门信息</span></div>
<div class="table-responsive-md">
<table class="table table-bordered sys_table">
    <tr>
        <th class="w12rem_lg">上级部门</th>
        <td><asp:TextBox runat="server" ID="PGroup_L" CssClass="form-control max20rem" disabled="disabled" Text="无"></asp:TextBox></td>
    </tr>
    <tr>
        <th>部门名</th>
        <td>
            <ZL:TextBox runat="server" ID="GroupName_T" CssClass="form-control max20rem" AllowEmpty="false" /></td>
    </tr>
    <tr>
        <th>管理员：</th>
        <td>
            <input type="button" value="选择" onclick="user.sel('manage','plat');" class="btn btn-info" />
             <table class="table table-bordered table-striped mt-2">
                <thead><tr><td>ID</td><td>姓名</td><td>操作</td></tr></thead>
                <tbody id="manage_body"></tbody>
             </table>
            <asp:HiddenField runat="server" ID="manage_hid" />
        </td>
    </tr>
    <tr>
        <th>组成员</th>
        <td>
            <input type="button" value="选择" onclick="user.sel('member', 'plat');" class="btn btn-info" />
            <table class="table table-bordered table-striped mt-2">
                <thead><tr><td>ID</td><td>姓名</td><td>操作</td></tr></thead>
                <tbody id="member_body"></tbody>
             </table>
            <asp:HiddenField runat="server" ID="member_hid" />
        </td>
    </tr>
     <tr>
        <th>描述</th>
        <td>
            <asp:TextBox runat="server" ID="GroupDesc_T" CssClass="form-control max20rem" /></td>
    </tr>
    <tr><th></th><td>
        <asp:Button runat="server" ID="Save_Btn" Text="保存信息" OnClick="Save_Btn_Click" CssClass="btn btn-outline-info" />
        <a href="GroupAdmin.aspx" class="btn btn-outline-danger">取消保存</a>
                 </td></tr>
</table>
</div>
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<script src="/JS/Controls/ZL_Array.js"></script>
<script>
//改为类的方式(是否sel等也放置进入)
    var manage = { select: "manage", list: [], $db: $("#manage_hid"), $body: $("#manage_body"), tlp: '<tr id="tr_@UserID"><td>@UserID</td><td>@HoneyName</td><td><a href="javascript:;" onclick="manage.del(@UserID);" title="删除"><i class="zi zi_times"></a></td></tr>' };
    var member = { select: "member", list: [], $db: $("#member_hid"), $body: $("#member_body"), tlp: '<tr id="tr_@UserID"><td>@UserID</td><td>@HoneyName</td><td><a href="javascript:;" onclick="member.del(@UserID);" title="删除"><i class="zi zi_times"></a></td></tr>' };
manage.init = function () {
    var ref = this;
    var val = ref.$db.val();
    if (val && val != "" && val != "[]") { ref.list = JSON.parse(val); ref.$db.val(ref.list.GetIDS("UserID")); ref.render(); }
    user.hook[ref.select] = function (list, select) {
        ref.list.addAll(list, "UserID");
        ref.render();
        //同时添加到组成员
        member.list.addAll(list, "UserID");
        member.render();
        CloseComDiag();
    }
}
manage.render = function () {
    var ref = this;
    var $items = JsonHelper.FillItem(ref.tlp, ref.list, null);
    ref.$body.html("").append($items);
    ref.$db.val(ref.list.GetIDS("UserID"));
}
manage.del = function (uid) {
    var ref = this;
    ref.$body.find("#tr_" + uid).remove();
    ref.list.RemoveByID(uid, "UserID");
    ref.$db.val(manage.list.GetIDS("UserID"));
}
//-----------------------------
member.init = function () {
    var ref = this;
    var val = ref.$db.val();
    if (val && val != "" && val != "[]") { ref.list = JSON.parse(val); ref.render(); }
    user.hook[ref.select] = function (list, select) {
        ref.list.addAll(list, "UserID");
        ref.render();
        CloseComDiag();
    }
}
member.render = function () {
    var ref = this;
    var $items = JsonHelper.FillItem(ref.tlp, ref.list, null);
    ref.$body.html("").append($items);
    ref.$db.val(ref.list.GetIDS("UserID"));
}
member.del = function (uid) {
    var ref = this;
    ref.$body.find("#tr_" + uid).remove();
    ref.list.RemoveByID(uid, "UserID");
    ref.$db.val(member.list.GetIDS("UserID"));
    //若是管理员，也删除
    //manage.del(uid);
}
$(function () {
    manage.init();
    member.init();
})
</script>
</asp:Content>