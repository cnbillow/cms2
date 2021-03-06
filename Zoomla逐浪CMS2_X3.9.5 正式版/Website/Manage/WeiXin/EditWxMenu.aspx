﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditWxMenu.aspx.cs" Inherits="ZoomLaCMS.Manage.WeiXin.EditWxMenu"  MasterPageFile="~/Manage/I/Index.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>自定义菜单</title>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<asp:Label runat="server" ID="Bread_L"></asp:Label>
<div class="container-fluid pr-0">
<div class="row sysRow list_choice table-responsive-md">
    <div class="col-md-3">
        <div class="card">
            <!-- Default panel contents -->
            <div class="card-header">
                菜单管理 
                    <div class="pull-right menu_option">
                        <a href="javascript:;" onclick="ShowAddMenu(-1)"><span class="zi zi_plus"></span></a>
                        <a href="javascript:;" onclick="SaveMenu()"><span class="zi zi_floppyDisk"></span></a>
                    </div>
            </div>
            <!-- List group -->
			<div class="wx_left_menu mb-5">
            <ul class="list-group" id="menu_ul">
            </ul>
			</div>
        </div>
    </div>
    <div class="col-md-9">
        <div class="card">
            <!-- Default panel contents -->
            <div class="card-header">
                定义菜单
                        <div class="pull-right"></div>
            </div>
            <div class="card-body">
                <div class="control_panel">
                    <div class="action items">
                        <h3 id="tip">提示</h3>
                        <div class="container-fluid option_panel">
                            <div class="">
                                <ul class="sys_ul">
                                    <li class="col-md-2 col-sm-2 col-xs-5"></li>
                                    <li class="col-md-3 col-sm-4 col-xs-5">
                                        <div data-tip="点击为选中项创建子菜单" onclick="ShowAddMenu(curMenu.index)" class="option parent">
                                            <span class="zi zi_edit"></span>
                                            <br />
                                            <b>创建子菜单</b>
                                        </div>
                                    </li>
                                    <li class="col-md-3 col-sm-4 col-xs-5">
                                        <div onclick="ShowSetLink()" data-tip="用户点击该菜单后,客户端立即跳转页面" class="option child">
                                            <span class="zi zi_link"></span>
                                            <br />
                                            <b>跳转链接</b>
                                        </div>
                                    </li>
                                    <li class="col-md-2 col-sm-2 col-xs-5"></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="action link_view" style="display: none;">
                        <h3 class="gray_9"></h3>
                        <div class="w-100" style="margin: 10px, auto; display: inline-block;">
                            <div class="input-group">
                                <span class="input-group-prepend" id="basic-addon1"><span class="input-group-text"><i class="zi zi_link"></i></span></span>
                                <input type="text" id="linkview_t" class="form-control disabled" />
                            </div>
                        </div>
                        <div class="text-right">
                            <button type="button" class="btn btn-outline-info mt-2" onclick="SaveUrl()">保存链接</button>
                            <button type="button" onclick="SelAction()" class="btn btn-outline-info mt-2">更改动作</button>
                        </div>
                    </div>
                    <div class="action pre_div" style="display: none;">
                        <iframe id="pre_ifr" src="" style="width: 330px; margin-left: 30%; border: none; height: 700px;"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
	</div>
	</div>
    <input type="hidden" id="preview_hid" />
    <div class="Conent_fix text-center">
        <button type="button" class="btn btn-info" onclick="SaveMenu()"><i class="zi zi_floppyDisk"></i> 保存菜单</button>
        <button type="button" class="btn btn-outline-info" onclick="PreViewMenu()"><i class="zi zi_eye"></i> 手机预览</button>
    </div>



    <div class="modal fade" id="AddMenu">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
					<h4 class="modal-title">添加菜单</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="text-center p-2">
                    <input type="text" id="menuname_t" class="form-control" placeholder="输入菜单按钮名称" /><br />
                    <div class="m-1">
                        <button type="button" class="btn btn-info mt-2" onclick="AddMenu()">确定</button>
                        <button type="button" onclick="CloseAddMenu()" class="btn btn-outline-info mt-2">取消</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="SetLink">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
					<h4 class="modal-title">添加菜单</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="text-center m-2">
                    <input type="text" id="link_t" class="form-control" />
                    <div class"m-1">
                        <button type="button" class="btn btn-info mt-2" onclick="SetLink()">确定</button>
                        <button type="button" onclick="$('#SetLink').modal('hide');" class="btn btn-outline-info mt-2">取消</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="/JS/Controls/ZL_Dialog.js"></script>
    <script src="/JS/Modal/APIResult.js"></script>
    <script>
        var menudata = [];
        var curMenu = {};//当前选中的菜单
        $(function () {
            //InitMenu();
            GetWxData();
            BindMenuEvent();
            BindOptionEvent();
        });
        function BindMenuEvent() {
            $("#menu_ul li").click(function () {
                $(".action").hide();
                $(".items").show();
                $("#menu_ul li").removeClass('li_active');
                $(this).addClass('li_active');
                GetSelMenu();
            });
        }
        //检查并选中菜单对象
        function GetSelMenu() {
            $(".option").hide();//隐藏所有选项
            if ($("#menu_ul .li_active")[0] && $("#menu_ul .li_active").data('index') >= 0) {
                var $active = $("#menu_ul .li_active");
                curMenu = menudata[parseInt($active.data('index'))];
                curMenu.index = $active.data('index');
                if (curMenu.sub_button && $active.data('pindex') == undefined && curMenu.sub_button.length > 0) {//判断该菜单是否已添加了子菜单
                    $('.parent').show();
                    $("#tip").text('该菜单已有子菜单，不能设置其他动作!');
                } else {
                    if ($active.data('pindex') >= 0) {//子菜单
                        curMenu = curMenu.sub_button[parseInt($active.data('pindex'))];
                        curMenu.pindex = $active.data('pindex');
                        $('.child').show();//显示子菜单动作选项
                    }
                    else { $('.option').show(); }
                    $("#tip").text('请选择用户点击菜单时的动作!');
                    //判断是否已有动作
                    if (curMenu.type == "view") { linkView(); }
                }
            } else {
                $("#tip").text('请选中要设置的菜单!');
            }
        }
        //选择动作
        function SelAction() {
            curMenu.type = '';
            $(".action").hide();
            $(".items").show();
            GetSelMenu();
        }
        //显示外部链接动作
        function linkView() {
            $(".action").hide();
            $(".link_view").show();
            $("#linkview_t").val(curMenu.url);
        }
        //保存菜单外部链接
        function SaveUrl() {
            curMenu.url = $("#linkview_t").val();
        }
        //绑定动作选项事件
        function BindOptionEvent() {
            $(".option").hover(function () {
                $("#tip").text($(this).data("tip"));
            }, function () {
                $("#tip").text('提示');
            });
        }
        function GetWxData() {
            $.post("EditWxMenu.aspx?action=get&appid=<%:AppId%>", {}, function (data) {
                var model = APIResult.getModel(data);
                console.log(model.result);
                if (APIResult.isok(model)) {
                    menudata = model.result.menu.button;
                }
                else {
                    var ret = JSON.parse(model.retmsg);
                    if (!ret.errmsg == "ok") { alert("保存出错!") }
                }
                InitMenu();
            })
        }
        //初始化微信菜单
        function InitMenu() {
            var tlp = "<li class='list-group-item' @data>@menutlp</li>";
            //父菜单模板
            var menutlp = "<span class='zi zi_list'></span> <input type='text' value='@name' class='form-control text_s' onchange='EditMenu(this,@index);'/>"
                + "<div class='pull-right'><a href='javascript:;' onclick='ShowAddMenu(@index)'><span class='zi zi_plus'></span></a> "
                + "<a href='javascript:;' onclick='removeMenu(@index)'><span class='zi zi_trashalt'></span></a></div>";
            var childtlp = "<span class='zi  zi_circleRights'></span> <span class='zi zi_edit'></span>  <input type='text' value='@name' class='form-control text_s' onchange='EditMenu(this,@index);'/>"//子菜单模板
                + "<div class='pull-right'><a href='javascript:;' onclick='removeChMenu(@index,@pindex)'><span class='zi zi_trashalt'></span></a></div>"
            var listhtml = "";
            var menucout = 18;//微信规定最大菜单数为18个
            for (var i = 0; i < menucout; i++) {
                var menuname = "<span class='zi zi_minus gray_c'></span>";//菜单名字，默认-
                if (menudata[i]) {
                    menuname = menutlp.replace(/@name/g, menudata[i].name).replace(/@index/g, i);
                    listhtml += tlp.replace(/@menutlp/g, menuname).replace(/@data/g, "data-index=" + i);
                    if (menudata[i].sub_button) {
                        for (var j = 0; j < menudata[i].sub_button.length; j++) {//遍历子菜单
                            menuname = childtlp.replace(/@name/g, menudata[i].sub_button[j].name);
                            listhtml += tlp.replace(/@menutlp/g, menuname).replace(/@index/g, i).replace(/@pindex/, j).replace(/@data/g, "data-index=" + i + " data-pindex=" + j);
                            menucout--;//减去子菜单占掉的菜单数
                        }
                    }
                } else {
                    listhtml += tlp.replace(/@menutlp/g, menuname);
                }
            }
            $("#menu_ul").html(listhtml);
            BindMenuEvent();
            GetSelMenu();//检查选中菜单
        }
        //增加菜单
        function AddMenu() {
            var index = parseInt($("#menuname_t").data('index'));
            //添加父菜单
            if (index < 0) {
                menudata.push({ name: $("#menuname_t").val(), key: '' });
            } else {
                //添加子菜单
                if (!menudata[index].sub_button)
                { menudata[index].sub_button = []; }
                menudata[index].sub_button.push({ name: $("#menuname_t").val(), key: '' });
            }
            InitMenu();
            CloseAddMenu();
        }
        //编辑菜单
        function EditMenu(input, index) {
            var $li = $(input).closest("li");
            var index = $li.data("index");//所属父级
            var pindex = $li.data("pindex");//所属子级
            if (pindex != undefined) {
                menudata[index].sub_button[pindex].name = input.value;
            }
            else { menudata[index].name = input.value; }
        }
        //移除菜单
        function removeMenu(index) {
            menudata.splice(index, 1);
            InitMenu();
        }
        //移除子菜单
        function removeChMenu(index, cindex) {
            menudata[index].sub_button.splice(cindex, 1);
            if (menudata[index].sub_button.length <= 0)
                delete menudata[index].sub_button;
            InitMenu();
        }
        function ShowAddMenu(index) {
            if (index >= 0 && (menudata[index].sub_button && menudata[index].sub_button.length >= 5)) {
                alert("微信二级菜单数量最多为5个!");
                return;
            } else if (menudata.length >= 3 && index < 0) {
                alert("微信一级菜单数量最多为3个!");
                return;
            }
            $("#AddMenu").modal({});
            $("#menuname_t").val('');
            $("#menuname_t").data('index', index);//数据索引，用于判断添加菜单类型(子级、父级)
        }
        function CloseAddMenu() {
            $("#AddMenu").modal("hide");
        }
        function ShowSetLink() {
            $("#link_t").val('');
            $("#SetLink").modal({});
        }
        //设置外部链接
        function SetLink() {
            curMenu.type = "view";
            curMenu.url = "http://" + $("#link_t").val().replace("http://", "");
            linkView();
            $("#SetLink").modal("hide");
        }
        //保存菜单至微信
        function SaveMenu() {
            if (menudata.length > 0) {
                CheckData();
                $.post("EditWxMenu.aspx?action=create&appid=<%:AppId%>", { menus: JSON.stringify(menudata) }, function (data) {
                    var model = APIResult.getModel(data);
                    if (APIResult.isok(model)) { alert('保存成功!'); }
                    else {
                        var ret = JSON.parse(model.retmsg);
                        if (ret.errmsg == "ok") { alert('保存成功!'); } else { alert("保存出错!") }
                    }
                })
            } else {
                alert("请添加菜单!");
            }
        }
        //检测数据(不完整数据如:缺少type字段等将使用默认值代替)
        function CheckData() {
            for (var i = 0; i < menudata.length; i++) {
                if (!menudata[i].type && !menudata[i].sub_button) {//没有子菜单的情况下默认将它设为按钮类型
                    menudata[i].type = "click";
                    menudata[i].key = "button_" + i;
                } else if (menudata[i].sub_button) {//遍历子菜单
                    for (var j = 0; j < menudata[i].sub_button.length; j++) {
                        if (!menudata[i].sub_button[j].type) {//对没有设置类型的子菜单将它默认设为按钮类型
                            menudata[i].sub_button[j].type = "click";
                            menudata[i].sub_button[j].key = "menu_" + i + "_btn_" + j;
                        }
                    }
                }
            }
        }
        function PreViewMenu() {
            $("#preview_hid").val("{\"menu\":{\"button\":" + JSON.stringify(menudata) + "}}");
            $(".items").hide();
            $(".pre_div").show();
            $("#pre_ifr").attr('src', 'MenuPreView.aspx?Cid=preview_hid');
        }
		
		function navtoleft(){
		$("[data-pindex]").css({"padding-left":"3rem"});
		}
		setInterval(navtoleft,100);
    </script>
</asp:Content>
