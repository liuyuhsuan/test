flag=0;
function clock(){
  mydate=new Date();
  y=mydate.getFullYear();
  mon=mydate.getMonth();
  dy=mydate.getDay();
  dt=mydate.getDate();
  h=mydate.getHours();
  min=mydate.getMinutes();
  s=mydate.getSeconds();
  ms=mydate.getMilliseconds();
  if(flag==0){
    if(s>9){
    
      document.getElementById("time").innerHTML=h+":"+min+":"+s;
    }
    else{
      document.getElementById("time").innerHTML=h+":"+min+":"+"0"+s;
    }
  }
  else{
    document.getElementById("time").innerHTML=y+"."+mon+"."+dy;
  }
  setTimeout("clock()", 1000);
}
clock();
function timeChange(){
  if(flag==0) flag=1;
  else flag=0;
}