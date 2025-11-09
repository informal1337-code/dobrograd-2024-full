
function ENT:Draw()
    self:DrawModel() -- Рисуем модель
    render.SetBlend(0.3) -- Прозрачность
    self:DrawLocalPos(SHAPE_SQUARE, Angle(), Vector(0, 0, 0), Color(0, 255, 0))
    render.SetBlend(1.0)
end