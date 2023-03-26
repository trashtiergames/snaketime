--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu
    License: Attribution-NonCommercial-ShareAlike 4.0 International 
    https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end