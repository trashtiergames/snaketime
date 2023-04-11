--[[
    Original author: Colton Ogden
    cogden@cs50.harvard.edu
    License: Attribution-NonCommercial-ShareAlike 4.0 International 
    https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
]]

StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {}
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	-- Old functionality, tied to passing functions into statemachine
	-- self.current = self.states[stateName]()
	self.current = self.states[stateName]
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end