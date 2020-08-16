using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.Data;

namespace backendPoSlojevima.DAL
{
    public class TipObjaveDAL : ITipObjaveDAL
    {
        private readonly ApplicationDbContext _context;

        public TipObjaveDAL(ApplicationDbContext context)
        {
            _context = context;
        }

        public List<TipObjave> getAllTipObjave()
        {
            return _context.tip_objave.ToList();
        }
    }
}
