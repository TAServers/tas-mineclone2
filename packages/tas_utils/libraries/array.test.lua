local array = require("packages.tas_utils.libraries.array")

describe("tas.array", function()
	describe("append", function()
		it("should append all the values from array b to array a", function()
			-- Arrange
			local a = { 1, 2, 3 }
			local b = { 4, 5, 6 }

			-- Act
			array.append(a, b)

			-- Assert
			expect(a).toEqual({ 1, 2, 3, 4, 5, 6 })
		end)

		it("should do nothing to array a if array b is empty", function()
			-- Arrange
			local a = { 1, 2, 3 }
			local b = {}

			-- Act
			array.append(a, b)

			-- Assert
			expect(a).toEqual({ 1, 2, 3 })
		end)
	end)

	describe("forEach", function()
		it("should call the callback on each member of the array", function()
			-- Arrange
			local mockCallback = lest.fn()
			local testArray = { 1, 2, 3 }

			-- Act
			array.forEach(testArray, mockCallback)

			-- Assert
			expect(mockCallback).toHaveBeenCalledTimes(3)
			expect(mockCallback).toHaveBeenNthCalledWith(1, 1, 1, testArray)
			expect(mockCallback).toHaveBeenNthCalledWith(2, 2, 2, testArray)
			expect(mockCallback).toHaveBeenNthCalledWith(3, 3, 3, testArray)
		end)
	end)
end)
