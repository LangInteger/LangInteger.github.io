---
title: Curriculum Vitae
---

<div style="padding: 2.5% 2.5% 2.5% 2.5%">![Lang](index/Lang.jpg)</div>

<style>
    .container {
        /*margin: 50px auto;*/
        /*border: #408bff 1px solid;*/
    }

    }
    #fake {
        margin-left: 40px;
        position: absolute;
        color: #eee;
        font-family: 楷体;
        font-size: 1.5em;
        letter-spacing: 0.2em;
    }

</style>

<script>
	content = "送你一朵很小支的花<br>因为它也曾开过半夏<br>不怕风吹雨也打长沙<br>看层林尽染等到朝霞";
	str = "送你一朵很小支的花<br>因为它也曾开过半夏<br>不怕风吹雨也打长沙<br>看层林尽染等到朝霞";
    function check() {
        var pwd = document.getElementById("pwd").value;
        if (pwd == '42') {
        	document.getElementById("pwd").value = "";
        	document.getElementById("pwd").placeholder = "Congratulations";
            var mainDiv = document.getElementById("main");
            mainDiv.style.display = "";
        } else {
        	document.getElementById("pwd").value = "";
        	document.getElementById("pwd").placeholder = "Wrong, Try Again";
        	var fakeDiv = document.getElementById("fake");
        	setTimeout("p1()", 200);
        }
    }

    var i = 0;
    function p1() {
        var str = content.substr(0, i);
        document.getElementById("fake").innerHTML = str + "_";
        i++;
        if (i > content.length){
            setTimeout("p2()", 200);
            return;
        }
        setTimeout("p1()", 100);
    }

    function p2() {
        document.getElementById("fake").innerHTML = str + "\\";
        setTimeout("p3()", 50)
    }
    function p3() {
        document.getElementById("fake").innerHTML = str + "|";
        setTimeout("p4()", 50)
    }
    function p4() {
        document.getElementById("fake").innerHTML = str + "/";
        setTimeout("p5()", 50)
    }
    function p5() {
        document.getElementById("fake").innerHTML = str + "-";
        setTimeout("p2()", 50)
    }

</script>

<div style="width: 100%; text-align: center">
	<input type="password" id="pwd" placeholder=" 输入密码 " 
	style="border: 1px solid #ccc;
                padding: 7px 0px;
                border-radius: 3px;
                padding-left:5px;
                -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
                box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
                -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
                -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
                transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s">
	<input type="submit" value="GO" onclick="check()" 
		style="background: repeat 0px 0px; width:100px; height: 44px; margin: 20px 0px 20px 0px;">
	<div id="fake" style="height: 5em ; 
			margin-left: 40px;
	        position: relative;
	        color: #aaa;
	        font-family: 楷体;
	        font-size: 1.5em;
	        letter-spacing: 0.2em;">
	</div>
</div>

<div id="main" style="display: none">
[Click Here](cv.html)
</div>

