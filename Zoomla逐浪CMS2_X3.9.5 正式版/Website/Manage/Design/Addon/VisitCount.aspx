﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VisitCount.aspx.cs" Inherits="ZoomLaCMS.Manage.Design.Addon.VisitCount" MasterPageFile="~/Manage/I/Index.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>浏览统计</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<div id="template" runat="server" class="template">
    <ol class="breadcrumb fixed-top">
        <li class="breadcrumb-item"><a href='<%=CustomerPageAction.customPath2 %>Main.aspx'>工作台</a></li>
        <li class="breadcrumb-item"><a href='../Default.aspx'>动力模块</a></li>
        <li class="breadcrumb-item"><a href='../SceneList.aspx'>场景列表</a></li>
        <li class="breadcrumb-item"><a href="VisitCount.aspx">访问统计</a></li>
        <div id="help" class="pull-right text-center pr-2"><a href="javascript:;" id="sel_btn" class="help_btn"><i class="zi zi_search"></i></a></div>
        <div id="sel_box" runat="server">
            <span class="pull-left">场景名称：</span>
            <div class="input-group pull-left max20rem">
                <asp:TextBox runat="server" ID="souchkey" class="form-control" placeholder="请输入需要搜索的内容" />
                <span class="input-group-append">
                    <asp:LinkButton runat="server" CssClass="btn btn-outline-secondary" ID="souchok" OnClick="souchok_Click"><span class="zi zi_search"></span></asp:LinkButton>
                </span>
            </div>
        </div>
    </ol>
	<div class="list_choice pr-1">
    <div class="template">
        <ul class="nav nav-tabs hidden-xs hidden-sm">
            <li class="nav-item"><a class="nav-link" href="#tab_detail" data-toggle="tab" onclick="showtabs('detail')">实时访客</a></li>
            <li class="nav-item"><a class="nav-link" href="#tab_overview" data-toggle="tab" onclick="showtabs('overview')">访问概览</a></li>
        </ul>
        <div id="Detail_Div" class="table-responsive" runat="server">
            <table class="table table-striped table-bordered table-hover">
                <tr>
                    <th>场景标题</th>
                    <th>访问人</th>
                    <th>类型</th>
                    <th>IP地址</th>
                    <th>访问时间</th>
                    <th>操作</th>
                </tr>
                <tr id="Empty_Detail" runat="server" visible="false"><td colspan="6">数据为空</td></tr>
                <ZL:Repeater ID="Detail_RPT" BoxType="dp" runat="server" PageSize="20" PagePre="<tr id='page_tr'><td colspan='6' id='page_td'>" PageEnd="</td></tr>" OnItemCommand="Detail_RPT_ItemCommand" >
                    <ItemTemplate>
                        <tr>
                            <td><a href="VisitCount.aspx?infoid=<%#Eval("InfoID") %>"  title="浏览"><%#Eval("InfoTitle") %></a></td>
                            <td><%#GetUser() %></td>
                            <td><%#GetSEType() %></td>
                            <td><span title="<%#Eval("IP") %>" style="cursor: pointer"><%#GetIpLocation() %></span></td>
                            <td><%#Eval("CDate","{0:yyyy-MM-dd HH:mm:ss}") %></td>
                            <td>
                                <a href="/h5/<%#Eval("InfoID") %>" target="_blank" title="浏览"><i class="zi zi_globe"></i>浏览</a>
                                <asp:LinkButton ID="del_btn" runat="server" CommandName="del" CommandArgument='<%# Eval("ID") %>' OnClientClick="return confirm('确定删除这条浏览记录吗?')"><i class="zi zi_trashalt"></i>删除</asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </ZL:Repeater>
            </table>
        </div>
        <div id="OView_Div" runat="server" class="table-responsive" visible="false">
            <table class="table table-striped table-bordered table-hover">
                <tr id="Title_Tr" runat="server">
                    <th>ID</th>
                    <th>场景标题</th>
                    <th>访问量</th>
                    <th>最近一次访问时间</th>
                    <th>操作</th>
                </tr>
                <tr id="Empty_OView" runat="server" visible="false"><td colspan="7">数据为空</td></tr>
                <ZL:ExRepeater runat="server" ID="OView_RPT" BoxType="dp" PageSize="20" PagePre="<tr id='page_tr'><td colspan='5' id='page_td'>" PageEnd="</td></tr>">
                    <ItemTemplate>
                        <tr ondblclick="location='VisitDetail.aspx?title=<%#Eval("InfoTitle") %>&id=<%#Eval("InfoID") %>'">
                            <td><%#Eval("ID") %></td>
                            <td><a href="/h5/<%#Eval("InfoID") %>" target="_blank"><%#Eval("InfoTitle") %></a></td>
                            <td><%#Eval("VisitCount") %></td>
                            <td><%#Eval("CDate","{0:yyyy-MM-dd HH:mm:ss}") %></td>
                            <td>
                                <a href="VisitDetail.aspx?title=<%#Eval("InfoTitle") %>&id=<%#Eval("InfoID") %>" title="访问详情"><i class="zi zi_listul"></i>详情</a>
                                <a href="/h5/<%#Eval("InfoID") %>" target="_blank" title="浏览"><i class="zi zi_globe"></i>浏览</a>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        <div class="clearfix"></div>
                    </FooterTemplate>
                </ZL:ExRepeater>
            </table>
        </div>
    </div>
	</div>
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
    <script src="/JS/Controls/ZL_Dialog.js"></script>
    <script>
        $(function () {
            $("ul.nav li").find("a").removeClass("active");
            $("a[href='#tab_<%=view%>']").parent().find("a").addClass("active");
        })
        var userdiag = new ZL_Dialog();
        function seluser(id) {
            userdiag.reload = true;
            userdiag.title = "查看用户";
            userdiag.url = "../../User/Userinfo.aspx?id=" + id;
            userdiag.backdrop = true;
            userdiag.maxbtn = false;
            userdiag.ShowModal();
        }
        function CloseDiag() {
            userdiag.CloseModal();
            CloseComDiag();
        }
        $("#sel_btn").click(function () {
            if ($("#sel_box").css("display") == "none") {
                showsel();
            }
            else {
                $(this).removeClass("active");
                $("#sel_box").slideUp(200);
                $(".template").css("margin-top", "0");
            }
        });
        function showsel() {
            $(this).addClass("active");
            $("#sel_box").slideDown(300);
            //$(".template").css("margin-top", "42px");
        }
        function showtabs(view) {
            location.href = "VisitCount.aspx?view=" + view;
        }
    </script>
</asp:Content>

