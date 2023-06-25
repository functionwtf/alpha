// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./DateTimeLibrary.sol";

contract DoorAccessControl {
    struct TimeInterval { //times are in hours since midnight
        uint8 startTime;
        uint8 endTime;
    }

    mapping(address => mapping(uint8 => TimeInterval[])) public weeklySchedules;

    event ScheduleUpdate(address indexed user, uint8 dayOfWeek, uint8 startTime, uint8 endTime);

    function setDailySchedule(address _user, uint8 _dayOfWeek, uint8 _startTime, uint8 _endTime) public {
        require(_dayOfWeek < 7, "Day of week must be between 0 and 6");
        require(_startTime < 24 && _endTime < 24, "Time must be between 0 and 23 hours");

        weeklySchedules[_user][_dayOfWeek].push(TimeInterval(_startTime, _endTime));

        emit ScheduleUpdate(_user, _dayOfWeek, _startTime, _endTime);
    }

    function checkAccess(address _user) public view returns (bool) {
        uint256 currentTimestamp = block.timestamp;
        uint8 currentDayOfWeek = uint8(BokkyPooBahsDateTimeLibrary.getDayOfWeek(currentTimestamp));
        uint8 currentHour = uint8(BokkyPooBahsDateTimeLibrary.getHour(currentTimestamp));

        TimeInterval[] storage todaySchedule = weeklySchedules[_user][currentDayOfWeek];

        for (uint i; i < todaySchedule.length; ++i) {
            if (currentHour >= todaySchedule[i].startTime && currentHour <= todaySchedule[i].endTime) {
                return true;
            }
        }
        return false;
    }
}
