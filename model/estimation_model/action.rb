require_relative './task'
require_relative './anomaly'

ANOMALIES_REGULATOR = 10

class Action
  attr_reader :team_member,
              :task_type,
              :task,
              :time_spent,
              :done

  def initialize(team_member, task)
    @team_member = team_member
    team_member.is_busy = true
    @task = task
    @task_type = task.task_type
    task.is_worked_on = true
    @time_spent = 0
    @done = false
  end

  def tick(process)
    #check and get required knowledge for the task
    if @task.knowledge > @team_member.knowledge
      communication_skill = @team_member.skills.find {|s| s.name == "communication"}
      if !communication_skill.nil?
        knowledge_gap = @task.knowledge - @team_member.knowledge
        if knowledge_gap <= communication_skill.level
          suitable_member = process.team.find {|s| s.knowledge >= @task.knowledge}
          if !suitable_member.nil?
            @team_member.knowledge = @task.knowledge
            return
          end
        end
      end

      learning_skill = @team_member.skills.find {|s| s.name == "learning"}
      if learning_skill.nil?
        learning_skill = Skill.new('learning', 1)
      end
      @team_member.knowledge += learning_skill.level
      @team_member.knowledge = [@team_member.knowledge, @task.knowledge].min
      return
    end

    @time_spent += 1

    #incase the task is an anomaly
    if @task_type == "anomaly"
      if @time_spent == @task.time_required
        @task.feature.completed += @task.time_required
        process.backlog.delete @task
        @team_member.is_busy = false
        @done = true
      end
      return
    end


    #generate anomalies
    probability = 0.0
    gap = 0
    if @task.required_skills.each do |skill|
        tm_skill = @team_member.skills.find {|s| s.name == skill.name}
        if tm_skill.nil?
          probability += 100.1
          gap += skill.level
        else
          gap += [(skill.level - tm_skill.level),0].max
          tobeAdded = (skill.level - tm_skill.level).fdiv ANOMALIES_REGULATOR
          probability += tobeAdded
        end
      end
    end
    probability = [[probability, 0].max, 1].min
    if rand <= probability
      skills_total = @task.required_skills.reduce(0) {|acc, skill| acc + skill.level}
      time_max = (1.0 * gap / skills_total * ANOMALIES_REGULATOR).floor
      @task.feature.add_anomaly(Anomaly.new  [Skill.new(@task_type, rand(1..5))], "anomaly", rand(1..time_max), @task.feature)
    end


    if @task_type == "testing"
      #find anomalies
      unfound_anomalies =  @task.feature.anomalies.select {|an| !an.found}
      unless unfound_anomalies.length == 0
        testing_skill = @team_member.skills.find {|s| s.name == "testing"}
          unless testing_skill.nil?
            probability = testing_skill.level.fdiv 10
            if rand <= probability
              process.find_anomaly(unfound_anomalies[0])
              unfound_anomalies[0].found = true
            end
          end
      end
    end

    #check if task is complete
    if @time_spent == @task.time_required
      process.backlog.delete @task
      next_task = @task.feature.get_next_task
      if !next_task.nil? 
        process.backlog.push next_task
      end
      @task.feature.completed += @task.difficulty
      @team_member.is_busy = false
      @done = true
    end
  end
end
