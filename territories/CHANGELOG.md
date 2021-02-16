# 27/01/2020
Made persistent with database table. Use territories.sql file provided.
Sql save timer added to config.lua, default is 5 minutes.

# 28/02/2020
Fix for players being able to sling drugs multiple times within one action (dupe fix?).
Added multiple police job support in config.lua table.

# 1/03/2020
Added support for "job2" in ESX.
Requires setJob2 function and job2 table to be added in order to sync changing of job2 correctly.
Example:

In es_extended/server/classes/player.lua:CreateExtendedPlayer function, I added the following:
  self.job2 = {}

  self.setJob2 = function(job,grade)
    grade = tostring(grade)
    local lastJob = json.decode(json.encode(self.job2))

    if ESX.DoesJobExist(job, grade) then
      local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

      self.job2.id    = jobObject.id
      self.job2.name  = jobObject.name
      self.job2.label = jobObject.label

      self.job2.grade        = tonumber(grade)
      self.job2.grade_name   = gradeObject.name
      self.job2.grade_label  = gradeObject.label
      self.job2.grade_salary = gradeObject.salary

      self.job2.skin_male    = {}
      self.job2.skin_female  = {}

      if gradeObject.skin_male then
        self.job2.skin_male = json.decode(gradeObject.skin_male)
      end

      if gradeObject.skin_female then
        self.job2.skin_female = json.decode(gradeObject.skin_female)
      end

      TriggerEvent('esx:setJob2', self.source, self.job2, lastJob)
      TriggerClientEvent('esx:setJob2', self.source, self.job2)
    else
      print(('es_extended: ignoring setJob for %s due to job not found!'):format(self.source))
    end
  end

A command to set your job2 value in-game:
  TriggerEvent('es:addGroupCommand', 'setjob2', 'jobmaster', function(source, args, user)
    if tonumber(args[1]) and args[2] and tonumber(args[3]) then
      local xPlayer = ESX.GetPlayerFromId(args[1])

      if xPlayer then
        if ESX.DoesJobExist(args[2], args[3]) then
          xPlayer.setJob2(args[2], args[3])
        else
          TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That job does not exist.' } })
        end

      else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
      end
    else
      TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
    end
  end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
  end, {help = _U('setjob'), params = {{name = "id", help = _U('id_param')}, {name = "job", help = _U('setjob_param2')}, {name = "grade_id", help = _U('setjob_param3')}}})


NOTE: 
This was a "supported feature" request. It is not a guide to adding job2.
If you don't have job2 already working, don't try and add it purely because of this changelog.


# 4/03/2020
- Fix memory leak added in last update.
- Add missing check for job2.
- Add config option for item limit or item weight restrictions.

# 25/03/2020
- Fix for free drug processing/duplication issue when handing other player your required items during the animation process.
- Added config option to "smack cheaters" (kill the cheater, related to above bug).
  ## CHANGED FILES:
    - client/main.lua
      - function Smack
    - config.lua
      - Added "SmackCheaters" option


# 29/03/2020
- Added releasing of loaded anim dict that was left behind.
- If player dies in zone, they will no longer contribute to the influence of that area.
  ## CHANGED FILES:
    - client/main.lua
      - function Update

# 18/04/2020
- Added info to credentials.lua file.

# 20/05/2020
- Added config option per zone (search for 'openzone') to allow all players (and not just the controlling gang) to enter and use the drug production facility.
  ## CHANGED FILES:
    - client/main.lua
      - function CheckLocation
    - config.lua

- Fix for item limit config option not working with items that had no limit.
  ## REMOTE UPDATE/NO CHANGES