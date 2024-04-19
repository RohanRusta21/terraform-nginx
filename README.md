# terraform-nginx

I have used Terraform as my configuration management tool for the assignment. Terraform is an open source infrastructure as a tool by hashicorp. Code written in terraform is in hcl syntax. 
main1.tf is having the code for iniating the ec2 instance which is installing nginx to host the html code which is there in user_data. After successful initialization and installation we can access the html code in browser.

I have also used appropriate ports to be get publicly exposed and any http requests are redirected to https, those code is handled in default.conf which lies inside the user_data section.


To Access The Web Server
```shell
https://44.202.19.255/
```

### Images For References

<img width="1512" alt="Screenshot 2024-04-19 at 11 15 42 PM" src="https://github.com/RohanRusta21/terraform-nginx/assets/110477025/3dad9d43-b5fc-4453-886a-9dea07d7fdda">


<br>

![image](https://github.com/RohanRusta21/terraform-nginx/assets/110477025/41ef1b43-35ce-495d-98f7-009b4470ea96)
