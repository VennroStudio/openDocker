init:
	chmod +x ./Core/MainMenu.sh
	chmod +x ./Core/Project/Menu/ProjectMenu.sh
	chmod +x ./Core/Project/Menu/ProjectEditMenu.sh
	chmod +x ./Core/Project/Command/Create.sh
	chmod +x ./Core/Project/Command/List.sh
	chmod +x ./Core/Project/Command/EditBasic.sh
	chmod +x ./Core/Project/Command/EditSsh.sh
	chmod +x ./Core/Project/Command/EditDatabase.sh
	chmod +x ./Core/Project/Command/EditDumps.sh
	chmod +x ./Core/Project/Command/Delete.sh
	chmod +x ./Core/Project/Entity/Project.sh

menu:
	@./Core/MainMenu.sh

push:
	git add .
	git commit -m "update"
	git push