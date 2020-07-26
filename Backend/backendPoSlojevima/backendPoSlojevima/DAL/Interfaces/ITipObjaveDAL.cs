using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface ITipObjaveDAL
    {
        List<TipObjave> getAllTipObjave();
    }
}
