#!/usr/bin/env bash
#
#Script para nuevos despliegues en el primer ambiente
#
#Por Tecnomedia

#Parametros de conexion al API de Automic
automic_client="100"
automic_username="ARA_QA"
automic_department="AUTOMIC"
automic_pass="ARA_QA"
automic_host="10.67.73.20"
automic_port="80"
apiPath_applications="/ara/api/data/v1/applications"
apiPath_packages="/ara/api/data/v1/packages"
apiPath_executions="/ara/api/data/v1/executions"

#Parametros de configuracion de Automic
custom_type_name="Deployment"
folder_name="PACKAGES"
workflow_name="Deploy"
deployment_profile="QA"

main()
	{	
                VarsCreation
		if CommitType
        	        then
				if ApplicationExist
					then
               			        	if PackageCreate
		                               		then
                      				        	if PackageStatus
			                                        	then
                								if PackageDeploy
											then
												return 0	
											else
												return 1
										fi
               	              						else
										return 1
								fi
							else
								return 1
		      	                	fi
					else
						return 1
				fi
			else
				return 1
		fi
	}
VarsCreation()
	{
		#Parametros de consulta al API de Automic
		owner_name="$automic_client/$automic_username/$automic_department"
		login_data="$owner_name:$automic_pass"
		#Parametros de aplicacion de Automic
		artifactid=$(git remote -v | sed 's@^.*\shttp://\(.*\)\s(.*).*$@\1@g' | sort -u | sed 's@^.*/\(.*\).git.*$@\1@g')
		custom_artifactid=$artifactid
		custom_version=$(git describe --tags)
		version_full=$custom_version
		application_name=$artifactid
	}
CommitType()
        {
                tag=$(git describe --tags)
                commit_type=$(git show "$tag" --pretty=fuller | sed -e '4,$d' | sed 's@\s.*@@g' | tr \\n "_" | sed 's@tag_Tagger:_TaggerDate:_@TAG@g')
                ##### Se agrega "commit_type_2" para cubrir los dos escenarios posibles cuando se genera un tag en GIT desde la consola web o desde CLI
                commit_type_2=$(git show "$tag" --pretty=fuller | sed -e '5,$d' | sed 's@\s.*@@g' | sed '/commit\|Author:\|AuthorDate:/!d' | tr \\n "_" | sed 's@commit_Author:_AuthorDate:_@TAG@g')
                ##
                ##### Se agrega al if la variable "commit_type_2" 
                if [ "$commit_type" == "TAG" ] || [ "$commit_type_2" == "TAG" ]
                ##
                        then
                                tag_w_hash=$(echo -e "$tag" | grep -e "^.*\..*\..*-.*-g.*$")
                                if [ "$tag_w_hash" != "" ]
                                        then
                                                tag_hash=$(echo -e "$tag" | sed -e 's@^.*-g\(.*\)@\1@g')
                                                author=$(git log --all --source --author=autoversioner | grep -A 1 -e "$tag_hash" | grep -e "Author:" | sed 's@Author: \(.*\) <.*>@\1@g')
                                                if [ "$author" == "autoversioner" ]
                                                        then
                                                                tag=$(echo -e "$tag" | sed -e 's@^\(.*\)-.*-g\(.*\)@\1@g')
                                                fi
                                fi
                                custom_tag="$tag"
                                if [ "$custom_version" == "$custom_tag" ]
                                        then
                                                return 0
                                        else
                                                PrintMsgTopic "WARNING: La version del artefacto \"$custom_version\" y el TAG \"$custom_tag\" no son iguales"
                                                return 0
                                fi
                        else
                                PrintMsgTopic "No se despliega la version sin haber creado el TAG"
                                return 1
                fi
        }
ApplicationExist()
	{
                artifact_id=$(curl -s --connect-timeout 60 -D- -u $login_data -X GET -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_applications"/\?name\=$application_name | grep -nB 1 "\"name\"\: \"$application_name\"" | grep -e "id" | sed 's@^.*\"id\"\: \(.*\),.*$@\1@g')

                if [ "$artifact_id" != "" ]
                        then
                                return 0
                        else
                                PrintMsgTopic "La aplicación $artifact_name no existe en AUTOMIC"
                                return 1
                fi
 	}
PackageCreate()
	{
                PrintMsgTopic "Creando paquete en Automic"
                curl -s --connect-timeout 60 -D- -u $login_data -X POST -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_packages" -d '{"name": "'$version_full'","application":{"name": "'$application_name'"},     "custom_type":{"name": "'$custom_type_name'"},"owner": {"name": "'$owner_name'"},"folder": {"name": "'$folder_name'"},"custom": {"artifactid": "'$custom_artifactid'", "version": "'$custom_version'", "tag": "'$custom_tag'"},}' > package_creation_out.out
		package_creation=$(cat package_creation_out.out | head -n 1 | sed 's@^\(.*\)\r$@\1@g')
                if [ "$package_creation" == "HTTP/1.1 201 Created" ]
	                then
        	                PrintMsg "El paquete $version_full ha sido creado en la aplicacion $application_name"
				return 0
                elif [ "$package_creation" = "HTTP/1.1 400 Bad Request" ]
	                then
        	                PrintMsg "$package_creation"
                        	package_creation=$(cat package_creation_out.out | grep -e "^.*\"error\": " | sed 's@^.*\"error\": \(.*\)\,\r$@\1@g')
	                        PrintMsg "El paquete no ha sido creado por el siguiente error:\n$package_creation\n"
        	                return 1
                fi
	}	
PackageStatus()
	{
                package_id=$(cat package_creation_out.out | grep -B 3 -e "^.*\"owner\": {" | head -n 1 | sed 's@^  \"id\": \(.*\),.*$@\1@g')
                DeleteFile "package_creation_out.out"
                if [ "$package_id" != "" ]
	                then
        	                package_status=$(curl -s --connect-timeout 60 -D- -u $login_data -X GET -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_packages"/"$package_id" | head -n 1 | sed 's@^\(.*\)\r$@\1@g')
                	        if [ "$package_status" == "HTTP/1.1 200 OK" ]
                        		then
		                                return 0
                		        else
		                                PrintMsg "El paquete $package_id no esta disponible en automic"
                		                return 1
	                        fi
        	        else
                		PrintMsg "El paquete $package_id no esta disponible en automic"
	                        return 1
                fi
	}
PackageDeploy()
	{
		PrintMsgTopic "Desplegando paquete en Automic"
		execution_id=$(curl -s --connect-timeout 60 -D- -u $login_data -X POST -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_executions" -d '{"application":"'$application_name'","workflow":"'$workflow_name'","package":"'$version_full'","deployment_profile":"'$deployment_profile'","needs_manual_start":false,"install_mode":"OverwriteExisting"}' | grep -nA 3 "status" | tail -n 1 | sed 's@^.*\"id\"\: \(.*\).*\r$@\1@g')
                if [ "$execution_id" != "" ]
	                then
                                execution_status=$(curl -s --connect-timeout 60 -D- -u $login_data -X GET -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_executions"/"$execution_id" | grep -e "status" | sed 's@^.*\"status\"\: \"\(.*\)\",.*\r$@\1@g')
                                if [ "$execution_status" == "Active" ]
                                        then
                                                PrintMsg "Iniciando el despliegue del paquete $version_full de la aplicacion $application_name"
                                        else
                                                PrintMsg "No se inicia el despliegue del paquete $version_full de la aplicacion $application_name"
                                fi
                                end_flag="false"
                                while [ "$end_flag" == "false" ];do
                                        execution_status=$(curl -s --connect-timeout 60 -D- -u $login_data -X GET -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_executions"/"$execution_id" | grep -e "status" | sed 's@^.*\"status\"\: \"\(.*\)\",.*\r$@\1@g')
                                        if [ "$execution_status" == "Finished" ]
                                                then
                                                        PrintMsg "El despliegue del paquete $version_full de la aplicacion $application_name termino correctamente"
                                                        end_flag="true"
                                                        return 0
                                        elif [ "$execution_status" == "Canceled" ] || [ "$execution_status" == "Failed" ]
                                                then
                                                        PrintMsg "ERROR: El despliegue del paquete $version_full de la aplicacion $application_name se detuvo"
#                                                       reports=( $(curl -s --connect-timeout 60 -D- -u $login_data -X GET -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_executions"/"$execution_id"/report/content | grep -e "---------- Report ----------" -e "--------------------------------------------------------------------" -n | grep -A 1 -e "Report" | sed '$!N;s@^\(.*\):.*Report.*\n\(.*\):.*$@\1,\2@g') )
#                                                       for report in ${reports[*]};do
#                                                               echo -e "$report"
#                                                               curl -s --connect-timeout 60 -D- -u $login_data -X GET -H "Content-Type: application/json" http://"$automic_host":"$automic_port""$apiPath_executions"/"$execution_id"/report/content | sed -n "$report p"
#                                                       done
                                                        end_flag="true"
                                                        return 1
                                        fi
                                        sleep 5
                                done
        	        else
                                PrintMsg "No se inicia el despliegue del paquete $version_full de la aplicacion $application_name"
				return 1
		fi
	}
PrintMsg()
        {
                echo -e `date +"%Y-%m-%d %T.%4N"`" $1"
        }
PrintMsgTopic()
        {
                echo -e `date +"%Y-%m-%d %T.%4N"`"   --------------------------------------------------"
                echo -e `date +"%Y-%m-%d %T.%4N"`"  / $1"
                echo -e `date +"%Y-%m-%d %T.%4N"`" ----------------------------------------------------"
        }
DeleteFile()
        {
                if [ -f "$1" ]
	                then
        	                rm -rf "$1"
                fi
        }
#Inicio
main

