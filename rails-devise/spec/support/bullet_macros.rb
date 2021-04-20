module BulletMacros
  def disable_bullet(_reason:)
    Bullet.enable = false
    yield
    Bullet.enable = true
  end
end
