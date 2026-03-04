local wezterm = require 'wezterm'
local platform = require 'utils.platform'

---@alias WeztermGPUBackend 'Vulkan'|'Metal'|'Gl'|'Dx12'
---@alias WeztermGPUDeviceType 'DiscreteGpu'|'IntegratedGpu'|'Cpu'|'Other'

---@class WeztermGPUAdapter
---@field name string
---@field backend WeztermGPUBackend
---@field device number
---@field device_type WeztermGPUDeviceType
---@field driver? string
---@field driver_info? string
---@field vendor string

---@alias AdapterMap { [WeztermGPUBackend]: WeztermGPUAdapter|nil }|nil

---@class GpuAdapters
---@field __backends WeztermGPUBackend[]
---@field __preferred_backend WeztermGPUBackend
---@field __preferred_device_type WeztermGPUDeviceType
---@field DiscreteGpu AdapterMap
---@field IntegratedGpu AdapterMap
---@field Cpu AdapterMap
---@field Other AdapterMap
local GpuAdapters = {}
GpuAdapters.__index = GpuAdapters

GpuAdapters.AVAILABLE_BACKENDS = {
  windows = { 'Dx12', 'Vulkan', 'Gl' },
  linux = { 'Vulkan', 'Gl' },
  mac = { 'Metal' },
}

---@type WeztermGPUAdapter[]
GpuAdapters.ENUMERATED_GPUS = wezterm.gui.enumerate_gpus()

---@return GpuAdapters
---@private
function GpuAdapters:init()
  local initial = {
    __backends = self.AVAILABLE_BACKENDS[platform.os],
    __preferred_backend = self.AVAILABLE_BACKENDS[platform.os][1],
    DiscreteGpu = nil,
    IntegratedGpu = nil,
    Cpu = nil,
    Other = nil,
  }

  for _, adapter in ipairs(self.ENUMERATED_GPUS) do
    if not initial[adapter.device_type] then
        initial[adapter.device_type] = {}
    end
    initial[adapter.device_type][adapter.backend] = adapter
  end

  local gpu_adapters = setmetatable(initial, self)

  return gpu_adapters
end

---@see GpuAdapters.AVAILABLE_BACKENDS

---@return WeztermGPUAdapter|nil
function GpuAdapters:pick_best()
  local adapters_options = self.DiscreteGpu
  local preferred_backend = self.__preferred_backend

  if not adapters_options then
    adapters_options = self.IntegratedGpu
  end

  if not adapters_options then
    adapters_options = self.Other
    preferred_backend = 'Gl'
  end

  if not adapters_options then
    adapters_options = self.Cpu
  end

  if not adapters_options then
    wezterm.log_error('No GPU adapters found. Using Default Adapter.')
    return nil
  end

  local adapter_choice = adapters_options[preferred_backend]

  if not adapter_choice then
    wezterm.log_error('Preferred backend not available. Using Default Adapter.')
    return nil
  end

  return adapter_choice
end

---@param backend WeztermGPUBackend
---@param device_type WeztermGPUDeviceType
---@return WeztermGPUAdapter|nil
function GpuAdapters:pick_manual(backend, device_type)
  local adapters_options = self[device_type]

  if not adapters_options then
    wezterm.log_error('No GPU adapters found. Using Default Adapter.')
    return nil
  end

  local adapter_choice = adapters_options[backend]

  if not adapter_choice then
    wezterm.log_error('Preferred backend not available. Using Default Adapter.')
    return nil
  end

  return adapter_choice
end

return GpuAdapters:init()