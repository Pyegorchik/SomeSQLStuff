-- Задание 2

-- Как и в прошлом задании рекурсивно создаем таблицу менеждеров и подчиненных
-- Отдельно считаем для каждого менеджера количество их подчиненных
-- LEFT JOIN гарантирует что будут учтены все сотрудники и что как указано в задании "Если у сотрудника нет назначенных проектов или задач, отобразить NULL"

WITH RECURSIVE EmployeeHierarchy AS (
    -- Базовый случай: Иван Иванов (EmployeeID = 1)
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    
    UNION ALL
    
    -- Рекурсивный случай: все подчиненные
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
),

SubordinateCount AS (
    SELECT 
        ManagerID,
        COUNT(*) AS TotalSubordinates
    FROM Employees
    GROUP BY ManagerID
)

SELECT 
    eh.EmployeeID,
    eh.Name AS EmployeeName,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    GROUP_CONCAT(DISTINCT p.ProjectName SEPARATOR ', ') AS ProjectNames,
    GROUP_CONCAT(DISTINCT t.TaskName SEPARATOR ', ') AS TaskNames,
    COUNT(DISTINCT t.TaskID) AS TotalTasks,
    IFNULL(sc.TotalSubordinates, 0) AS TotalSubordinates
FROM 
    EmployeeHierarchy eh
LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN Projects p ON eh.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON eh.EmployeeID = t.AssignedTo
LEFT JOIN SubordinateCount sc ON eh.EmployeeID = sc.ManagerID
GROUP BY 
    eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName, sc.TotalSubordinates
ORDER BY 
    eh.Name;