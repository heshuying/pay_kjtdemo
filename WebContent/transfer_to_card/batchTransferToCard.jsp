<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>快捷通批量转账到卡网关接口测试页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is test page">
	
	<script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="js/jquery.i18n.properties-min-1.0.9.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="js/demo.js"></script>
	
	<link rel="stylesheet" type="text/css" href="css/demo.css" />
  </head>
  <body>
      <h4>快捷通批量转账到卡网关接口测试页面</h4>
      
      <span class="red">
   		使用步骤：<br>
   		1.点击[添加转账列表信息]按钮将转账列表详细参数放入转账列表(transfer_list)参数中<br>
   		2.点击[加密业务参数并设置到请求参数集合中]按钮将业务参数加密后放入请求参数集合(biz_content)参数中<br>
   		3.点击[提交支付]按钮将请求参数提交到快捷通网关
   	  </span>
      
      <div>
      <form id="form" action="https://zgateway.kjtpay.com/recv.do" method="post">
		
		<%		
        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
		String orderTime = format.format(new java.util.Date());
		java.text.DecimalFormat def = new java.text.DecimalFormat("000000");
		int b=(int)(Math.random()*1000000%1000000);//产生0-1000000的整数随机数
		String lstStr = def.format(b);
		String requestNo = orderTime + lstStr;
		String outTradeNo = orderTime + lstStr;
		
		java.text.SimpleDateFormat timestampFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timestamp = timestampFormat.format(new java.util.Date());
		%>
		<table border="1px;" cellspacing="0px;" cellpadding="0px;" width="100%">
			<tr>
				<th colspan="3">以下是请求公共参数，点[提交支付]按钮后将提交到快捷通网关</th>	
			</tr>
			<tr>
				<td width="15%">商户网站请求号:</td>
				<td width="15%"><input type="text" name="request_no" value="<%=requestNo%>"></td>
				<td>(请求号，字母数字下划线，确保每次请求唯一，非空)</td>
			</tr>
			<tr>
				<td>接口名称:</td>
				<td><input type="text" id="service" name="service" value="batch_transfer_card"></td>
				<td>(例如：transfer_to_account，非空)</td>
			</tr>
			<tr>
				<td>接口版本:</td>
				<td><input type="text" name="version" value="1.0"></td>
				<td>(目前版本：1.0，非空)</td>
			</tr>
			<tr>
				<td>合作者身份ID:</td>
				<td><input type="text" name="partner_id" value="200000058826"></td>
				<td>(平台或商户ID，商户直接接入快捷通的填商户ID，非空)</td>
			</tr>
			<tr>
				<td>字符集:</td>
				<td><input type="text" id='charset' name="charset" value="UTF-8"></td>
				<td>(类型有：UTF-8;GBK，非空)</td>
			</tr>
			<tr>
				<td>签名方式:</td>
				<td><input type="text" id="sign_type" name="sign_type" value="ITRUS"></td>
				<td>(签名方式只支持ITRUS/RSA，非空)</td>
			</tr>
			<tr>
				<td>签名:</td>
				<td><input type="text" id="sign" name="sign" value=""></td>
				<td>(请求参数签名，非空)<span class="red">对请求公共参数签名,签名结果放入[签名]中,post请求前对所有请求公共参数做urlEncode编码</span></td>
			</tr>
			<tr>
				<td>请求时间:</td>
				<td><input type="text" name="timestamp" value="<%=timestamp%>"></td>
				<td>(格式"yyyy-MM-dd HH:mm:ss"，如2017-06-24 13:07:56，请求时间必须在10分钟内，非空)</td>
			</tr>
			<tr>
				<td>请求参数集合支持的格式:</td>
				<td><input type="text" name="format" value="JSON"></td>
				<td>(业务请求参数集合支持的格式，仅支持JSON，非空)</td>
			</tr>
			<tr>
				<td>请求参数集合:</td>
				<td><input type="text" id="biz_content" name="biz_content" value=""></td>
				<td>(除公共请求参数外所有业务请求参数都必须放在这个参数中传递，非空)</td>
			</tr>
			
			
			<tr>
				<td colspan="3"><input type="button" id="submitBtn" value="提交支付" /></td>
			</tr>
		</table>	
    </form>
    </div>
    
    <div align="center"><hr>===我是分割线===<hr></div>
    
	<div id='bizContentDiv'>
		<table border="1px;" cellspacing="0px;" cellpadding="0px;" width="100%">
			<tr>
				<th colspan="3">以下是业务参数，业务参数都会加密后放入请求参数集合(biz_content)参数中<input type="button" id="encryptBtn" value="加密业务参数并设置到请求参数集合中" /></th>	
			</tr>
			
			<tr>
				<td width="15%">平台(商户)批次号:</td>
				<td width="15%"><input type="text" name="out_batch_no" value='<%=outTradeNo%>'></td>
				<td>(平台(商户)批次号字段只能是数字下划线字母，非空)</td>
			</tr>
			<tr>
				<td>转账总笔数:</td>
				<td><input type="text" name="transfer_num" value='1'></td>
				<td>(转账总笔数范围1-1000笔，非空)</td>
			</tr>
			<tr>
				<td>转账总金额:</td>
				<td><input type="text" name="transfer_amount" value='0.10'></td>
				<td>(转账总金额，必须为15位以内最大保留2位精度数字，非空)</td>
			</tr>
			<tr>
				<td>出款账号:</td>
				<td><input type="text" name="payer_identity" value='200000058826'></td>
				<td>(出款账号，最大长度32位，非空)</td>
			</tr>
			<tr>
				<td>出款标识类型:</td>
				<td><input type="text" name="payer_identity_type" value='1'></td>
				<td>(出款标识类型，需传1|2，1:快捷通ID，2:用户登陆号)</td>
			</tr>
			<tr>
				<td>业务产品码:</td>
				<td><input type="text" name="biz_product_code" value='10226'></td>
				<td>(业务产品码，必须为数字，非空)</td>
			</tr>
			<tr>
				<td>服务器异步通知页面地址:</td>
				<td><input type="text" name="notify_url" value='http://10.255.4.54:8002/AlphaTest/gateway/asyncNotify.do'></td>
				<td>(服务器异步通知地址，快捷通主动通知商户网站里指定的URL http/https路径，当订单完成后会回调商户并告知订单状态，可空)</td>
			</tr>
			<tr>
				<td>转账列表:</td>
				<td><input type="text" class="list" name="transfer_list" value=''></td>
				<td>(最多支持10个分润账号，可空)</td>
			</tr>
		</table>
		
		<div align="center"><hr>===我是分割线===<hr></div>
		
		<div class="detailInfoDiv">
			<table border="1px;" cellspacing="0px;" cellpadding="0px;" width="100%">
				<tr>
					<th colspan="3">以下是转账列表详细参数，该参数都会放入转账列表(transfer_list)参数中<input type="button" id="addDetailInfoBtn" value="添加转账列表信息" /></th>	
				</tr>
				<tr>
					<td width="15%">转账金额:</td>
					<td width="15%"><input type="text" name="amount" value='0.10'></td>
					<td>(当转账列表不空时非空，转账金额必须为15位以内最大保留2位精度数字)</td>
				</tr>
				<tr>
					<td>平台(商户)订单号:</td>
					<td><input type="text" name="out_trade_no" value='<%=outTradeNo%>'></td>
					<td>(当转账列表不空时非空，平台(商户)订单号，长度范围6-32，字段只能是数字下划线字母)</td>
				</tr>
				<tr>
					<td>银行卡账户名:</td>
					<td><input type="text" name="bank_account_name" value=''></td>
					<td>(当转账列表不空时可空，银行卡账户名，字段最大长度32位，不能包含数字)</td>
				</tr>
				<tr>
					<td>银行卡号:</td>
					<td><input type="text" name="bank_card_no" value=''></td>
					<td>(当转账列表不空时可空，银行卡号，字段必须是6-32位，必须为字母数字)</td>
				</tr>
				<tr>
					<td>银行编码:</td>
					<td><input type="text" name="bank_code" value='ABC'></td>
					<td>(当转账列表不空时可空，银行编码，字段最大长度16位，必须为字母，取值参考接口文档)</td>
				</tr>
				<tr>
					<td>银行名称:</td>
					<td><input type="text" name="bank_name" value='中国农业银行'></td>
					<td>(当转账列表不空时可空，银行名称，字段超过最大长度16位，取值参考接口文档)</td>
				</tr>
				<tr>
					<td>支付产品码:</td>
					<td><input type="text" name="pay_product_code" value='14'></td>
					<td>(当转账列表不空时非空，支付产品码，字段最大长度2位，必须为数字)</td>
				</tr>
			</table>
		</div>
	</div>
  </body>
</html>