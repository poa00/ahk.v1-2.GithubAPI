; Generated by Auto-GUI 3.0.1
#SingleInstance Force
    #NoEnv 
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Gui Font, s9, Segoe UI
Gui Add, Button, ggo x184 y296 w120 h22, Give me code
Gui Add, Edit, vusername  x32 y144 w120 h21, github_username
Gui Add, Edit, vrepository x32 y192 w120 h21, github_repository

Gui Add, Edit, vFile x32 y240 w122 h21, File_DL_Name
Gui Add, Text, x184 y240 w186 h23 +0x200, Choose a name for saving locally
Gui Add, Button, grun x32 y296 w80 h22, Test / DL
Gui Add, CheckBox, vCheck x184 y144 w195 h23 +Checked, Check Update + Store Version
Gui Add, Text, x40 y8 w289 h79, Generate code that will: `n-Download latest releases from Github`,  `n-Store Version data Locally`,`n-Get info on version and changes, `n-Prompt for update only on vers=/=vers 

Gui Show, w369 h350, Use AHK to download Github Latest Releases 
Return

go:
    loop, 5
    {
      getcontrol()
      if (obj.full()="")
      {
        sleep 500
        continue
      }
      else        
          DisplayLog(obj.full(), obj.req())  
    }
Return

run:
    getcontrol() 
    txt := obj.full()
    FileAppend, 
    (C LTrim
    
    %txt%
    
    ), run.txt 
    filemove, run.txt, run.ahk, 1
    run, run.ahk, %A_ScriptDir%
    reload
Return

getcontrol()
{
    global
    GuiControlGet, repository
    GuiControlGet, username
    GuiControlGet, file
    GuiControlGet, drop
    GuiControlGet, check
    array := [repository, username, drop, file, check]
    obj := new Code(array)
}

Class Code {
    __New(array) {
        this.repo := array[1]
        this.user := array[2]
        this.drop := array[3]
        this.file := array[4]
        this.updt := array[5]
    }
    combine() {
        rep := `"""" this.user "/" this.repo `"""" 
        return rep
    } 
    
    baseline() {
        val=
        (C LTrim
        #Include Json.ahk    ;place in same dir as code
        #Include github.ahk  ;place in same dir as code 
        #SingleInstance, force
            #NoEnv
        
        )
        return val 
    }
    update() {
        if (this.updt=1)
        {
            scriptupdater=
            (C LTrim                
                        
            log := A_Appdatacommon "\log.txt"
            ;designate a log location, otherwise the script will send log.txt to appdata   
            
            ;stores log info, only downloads if log has vers < latest
            git.upd(log)
            )
        }
        else
        {
            script:=this.file
            scriptupdater=
            (C LTrim              
            git.DL("%script%") 
            )
        }
        return scriptupdater
    }
    
    req() {
        file :=  this.combine()
        script := this.file()
        log := this.update()
        necessary= 
        (C LTrim
        
        ;keep this above download object
        repos := %File%
        git := new Github(repos)
        
        %log%
        )
        return necessary 
    }
    
    full() {
        code := this.baseline() "`n" this.req()
        return code
    }
    
}

DisplayLog(FullCode, Partial) {
    
    global
    Gui new, hwndOne 
    Gui show, w364 h291, Code
    Gui Font, s9, Segoe UI
    Gui Add, Edit, vfull x16 y40 w143 h183
    Gui Add, Edit, vpatrial x176 y40 w143 h183
    Gui Add, Text, x25 y8 w120 h23 +0x200, Full
    Gui Add, Text, x176 y8 w120 h23 +0x200, Partial
    Gui Add, Button, gfuller x48 y240 w80 h23, Copy
    Gui Add, Button, gpatrialer x208 y240 w80 h23, Copy
    GuiControl,, full, %fullcode%
    GuiControl,, patrial, %Partial%
Return

fuller:
    clipboard := obj.full()
return

patrialer:
    clipboard := obj.req()
return

}

GuiEscape:
GuiClose:
    ExitApp
    