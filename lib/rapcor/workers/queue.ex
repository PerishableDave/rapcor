defmodule Rapcor.Workers.Queue do
  @queue Application.get_env(:rapcor, :worker_queue)

  def enqueue(module, args) do
    @queue.enqueue(Exq, "default", module, args)
  end

  def enqueue_in(module, delay, args) do
    @queue.enqueue_in(Exq, "default", delay, module, args)
  end
end
