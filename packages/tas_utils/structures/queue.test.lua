local Queue = require("packages.tas_utils.structures.queue")

describe("tas.Queue", function()
	it("should be able to create a new queue", function()
		-- Arrange
		local queue = Queue.new()

		-- Assert
		expect(queue:Size()).toBe(0)
	end)

	it("should add the given element when enqueued", function()
		-- Arrange
		local queue = Queue.new()

		-- Act
		queue:Enqueue("foo")

		-- Assert
		expect(queue:Size()).toBe(1)
	end)

	it("should remove the last element when dequeued", function()
		-- Arrange
		local queue = Queue.new()

		-- Act
		queue:Enqueue("foo")
		queue:Enqueue("bar")
		queue:Dequeue()

		-- Assert
		expect(queue:Size()).toBe(1)
		expect(queue:Dequeue()).toBe("bar")
	end)

	it("should throw an error if the queue is empty when dequeued", function()
		-- Arrange
		local queue = Queue.new()

		-- Assert
		expect(function()
			queue:Dequeue()
		end).toThrow()
	end)
end)
