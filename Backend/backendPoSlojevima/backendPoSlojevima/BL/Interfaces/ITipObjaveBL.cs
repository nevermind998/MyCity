using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface ITipObjaveBL
    {
        List<TipObjave> getAllTipObjave();
    }
}
