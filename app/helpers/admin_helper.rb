module AdminHelper
  #----------------
  # Place a modal anywhere with a button to toggle it
  #
  # Takes a hash of options and a block with the content
  #
  def modal_toggle(options={}, &block)
    render "/outpost/shared/modal", options: options, body: capture(&block)
  end
end
